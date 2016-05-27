/*
 * rfidTag.cc
 * Copyright (C) 2000 by the University of Southern California
 * $Id: rfidTag.cc,v 1.8 2005/08/25 18:58:01 johnh Exp $
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License,
 * version 2, as published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 59 Temple Place, Suite 330, Boston, MA 02111-1307, USA.
 *
 *
 * The copyright of this module includes the following
 * linking-with-specific-other-licenses addition:
 *
 * In addition, as a special exception, the copyright holders of
 * this module give you permission to combine (via static or
 * dynamic linking) this module with free software programs or
 * libraries that are released under the GNU LGPL and with code
 * included in the standard release of ns-2 under the Apache 2.0
 * license or under otherwise-compatible licenses with advertising
 * requirements (or modified versions of such code, with unchanged
 * license).  You may copy and distribute such a system following the
 * terms of the GNU GPL for this module and the licenses of the
 * other code concerned, provided that you include the source code of
 * that other code when and as the GNU GPL requires distribution of
 * source code.
 *
 * Note that people who make modified versions of this module
 * are not obligated to grant this special exception for their
 * modified versions; it is their choice whether to do so.  The GNU
 * General Public License gives permission to release a modified
 * version without this exception; this exception also makes it
 * possible to release a modified version which carries forward this
 * exception.
 *
 */


/*
 * File: Code for a new 'RfidTag' Agent Class for the ns
 *       network simulator
 * Author: Rafael Perazzo Barbosa Mota (perazzo@ime.usp.br), Setembro 2012
 *
 */

#include "rfidTag.h"
#include "rfidPacket.h"
#include <stdlib.h>
#include <time.h>
#include <random.h>
#include <math.h>

static class RfidTagClass : public TclClass {
public:
	RfidTagClass() : TclClass("Agent/RfidTag") {}
	TclObject* create(int, const char*const*) {
		return (new RfidTagAgent());
	}
} class_rfidTag;

RfidTagAgent::RfidTagAgent() : Agent(PT_RFIDPACKET), slot_(0), rng16_(0),state_(0), memory2_(-1)
{
	bind("packetSize_", &size_);
	bind("id_",&id_);
	bind("tagEPC_",&tagEPC_);
	bind("service_",&service_);
	bind("kill_",&kill_);
	bind("time_",&time_);
	bind("memory_",&memory_);
	bind("messages_",&debug_);
	bind("seed_",&seed_);
	bind("trace_",&trace_);
}

int RfidTagAgent::command(int argc, const char*const* argv)
{
  //The tag do not start communication.
  // If the command hasn't been processed by RfidReaderAgent()::command,
  // call the command() function for the base class
  //tags never start communication - passive tag
   return (Agent::command(argc, argv));
}

void RfidTagAgent::recv(Packet* pkt, Handler*)
{
  // IP HEADER
  hdr_ip* hdrip = hdr_ip::access(pkt);
  // RFID HEADER
  hdr_rfidPacket* hdr = hdr_rfidPacket::access(pkt);
  if (hdr->tipo_==FLOW_RT) { //READER PACKAGE
	  if (hdr->service_==SERVICE_TRACKING) {
	  	//CREATE RESPONSE PACKAGE
                Packet* pktret = allocpkt();
	        hdr_rfidPacket* rfidHeader = hdr_rfidPacket::access(pktret);
	        hdr_ip* ipHeader = hdr_ip::access(pktret);
	        rfidHeader->tagEPC_ = tagEPC_;
        	rfidHeader->id_ = hdr->id_;
	        rfidHeader->tipo_ = FLOW_TR;
        	rfidHeader->service_=hdr->service_;
	        ipHeader->daddr() = hdrip->saddr();
	        ipHeader->dport() = hdrip->sport();
		rfidHeader->ack_=1;
		if (hdr->singularization_==SING_NOSINGULARIZATION) {
                	if (hdr->id_!=id_) { 
                        	send(pktret,0);
                	}
          	}
          	else {
                	if (hdr->id_!=id_) {
                        	double tempo = Random::uniform(0,time_);
                        	Scheduler& sch = Scheduler::instance();
                        	sch.schedule(target_,pktret,tempo);
                	}
          	}
	  }
	  else if (hdr->service_==SERVICE_STANDARD) { 
		/*
		*EPCGLOBAL Radio-Frequency Identity Protocols
 		*Class-1 Generation-2 UHF RFID
		*Protocol for Communications at 860 MHz – 960 MHz
		*Version 1.2.0
		*/
		//make reply packet
		memory_=hdr->qValue_;
		//id_=hdr->id_; //REMOVED - 02/03/2013
	        if ((hdr->command_==RC_QUERY)&&(state_!=T_ACKNOWLEDGED)) {
			id_=hdr->id_;
			updateSlot();
			if (slot_==0) {
	                        state_=T_REPLY;
        	                sendPacket(pkt,RC_QUERY);
                        }
                        else {
                	 	state_=T_ARBITRATE;
                        }

		}
		else if ((hdr->command_==RC_QUERY)&&(state_==T_ACKNOWLEDGED)) {
			if ((hdr->mechanism_==0)||(id_!=hdr->id_)) {
				id_=hdr->id_;
                        	state_=T_READY;
				updateSlot();
                        	if (slot_==0) {
                                	state_=T_REPLY;
	                                sendPacket(pkt,RC_QUERY);
        	                }
                	        else {
                                state_=T_ARBITRATE;
                        	}
			}

                }

		else if ((hdr->command_==RC_QUERYADJUST)&&(state_!=T_ACKNOWLEDGED)) {
     			id_=hdr->id_;
			updateSlot();
			if (slot_==0) {
		                state_=T_REPLY;
		                sendPacket(pkt,RC_QUERYADJUST);
       			}
       			else {
               			state_=T_ARBITRATE;
		        }
		}
		else if ((hdr->command_==RC_QUERYREPLY)&&(hdr->tagEPC_==tagEPC_)) {
			id_=hdr->id_;
			state_=T_ACKNOWLEDGED;
			slot_--;
		        if (debug_) printf("(TAG IDENTIFIED) [%d] state(%d): slot value : %d\n",tagEPC_,state_,slot_);
			sendPacket(pkt,TC_REPLY);
	  	}
		else if ((hdr->command_==RC_QUERYREPLY)&&(hdr->tagEPC_==IP_BROADCAST)&&(slot_>0)) {
			id_=hdr->id_;
			if (state_!=T_ACKNOWLEDGED) {
				slot_=slot_-1;
			        if (debug_) printf("tag [%d] updated slot to (%d)\n",tagEPC_,slot_);
				if (slot_==0) {
                	                state_=T_REPLY;
                        	        sendPacket(pkt,RC_QUERYREPLY);
                        	}
                        	else {
                                	state_=T_ARBITRATE;
                        	}
			}
		}
	}
	else if (hdr->service_==SERVICE_EBTSA) { //EBTSA ALGORITHM
		memory_=hdr->qValue_; //Storing received Q Value in memory		
		if (hdr->command_==RC_EST) {
			state_=T_ARBITRATE;
			updateSlot(); //UPDATING SLOT
			//printf("Generated slot number: %d\n",slot_);
			if (slot_==0) {			
				state_=T_REPLY;				
				sendPacket(pkt,TR_EST_REPLY);
			}
			else {
				state_=T_ARBITRATE;			
			}
		}
		if (hdr->command_==RC_EST_FINISH) {
			state_=T_READY;		
		}
	}
	/* ESTIMATED DFSA ALGORITHM **/
	else if (hdr->service_==SERVICE_EDFSA) { //EDFSA ALGORITHM
		if ((hdr->command_==RC_QUERY)&&(state_!=T_ACKNOWLEDGED)) { //START AND ADJUST		
			if (hdr->reply_==0) {	//All tags should receive the query
				memory_=hdr->qValue_; //Storing received Q Value in memory
				state_=T_ARBITRATE;
				updateSlot2(); //UPDATING SLOT
				if (hdr->slotNumber_==slot_) { //time to reply
					state_=T_REPLY;
					//send packet
					sendPacket(pkt,TC_REPLY);
				}
			}
			else if (hdr->reply_>0) { //Only collided tags should receive the query
								
				if (hdr->reply_==slot_) { 
					memory_=hdr->qValue_; //Storing received Q Value in memory
					memory2_=hdr->reply_;					
					state_=T_ARBITRATE;					
					updateSlot2(); //UPDATING SLOT
					if (hdr->slotNumber_==slot_) { //time to reply
						state_=T_REPLY;
						//send packet
						sendPacket(pkt,TC_REPLY);
					}		
				}
				else if (hdr->reply_==memory2_) {
					memory_=hdr->qValue_; //Storing received Q Value in memory				
					state_=T_ARBITRATE;				
					updateSlot2(); //UPDATING SLOT
					if (hdr->slotNumber_==slot_) { //time to reply
						state_=T_REPLY;
						//send packet
						sendPacket(pkt,TC_REPLY);
					}
				}
			}
		}
		else if ((hdr->command_==RC_SING)&&(state_!=T_ACKNOWLEDGED)) {
			
			if (hdr->reply_==0) {	//All tags should receive the query
				if (hdr->slotNumber_==slot_) { //time to reply
					state_=T_REPLY;
					sendPacket(pkt,TC_REPLY);
				}
			}
			else if (hdr->reply_>0) {				
											
				if (hdr->reply_==memory2_) {
					if (hdr->slotNumber_==slot_) { //time to reply
						state_=T_REPLY;
						sendPacket(pkt,TC_REPLY);
					}	
				}
			}
		}
		else if ((hdr->command_==RC_QUERYREPLY)&&(state_!=T_ACKNOWLEDGED)) {
			state_=T_ACKNOWLEDGED;
		}

	}

  }
  else if (hdr->tipo_==FLOW_RT_ACK) { //Tag recebe um ACK
	id_=hdr->id_; //Grava o ID do leitor que confirmou o recebimento
  }
  else { //Descarta o pacote caso a origem não tenha sido um leitor
	Packet::free(pkt);
  }
  Packet::free(pkt);
  return;
}

void RfidTagAgent::updateSlot() {
	Random::seed_heuristically();
	rng16_=Random::uniform(0,pow(2,memory_)-1);
        if (state_!=T_ACKNOWLEDGED) {
		slot_=trunc(rng16_);
	}
        if (debug_) printf("tag [%d] state (%d) updated slot to:  %d\n",tagEPC_,state_,slot_);
}

void RfidTagAgent::updateSlot2() {
	Random::seed_heuristically();
	rng16_=Random::uniform(1,memory_);
        if (state_!=T_ACKNOWLEDGED) {
		slot_=round(rng16_);
	}
        if (debug_) printf("tag [%d] state (%d) updated slot to:  %d\n",tagEPC_,state_,slot_);
}

void RfidTagAgent::sendPacket(Packet* pkt, int command) {
	//IP HEADER
	hdr_ip* hdrip = hdr_ip::access(pkt);
	// RFID HEADER
	hdr_rfidPacket* hdr = hdr_rfidPacket::access(pkt);
	Packet* pktret = allocpkt();
        hdr_rfidPacket* rfidHeader = hdr_rfidPacket::access(pktret);
        hdr_ip* ipHeader = hdr_ip::access(pktret);
        rfidHeader->tagEPC_ = tagEPC_;
        rfidHeader->id_ = hdr->id_;
        rfidHeader->tipo_ = FLOW_TR;
	rfidHeader->service_ = hdr->service_;
	rfidHeader->singularization_ = hdr->singularization_;
	rfidHeader->command_=command;
	rfidHeader->rng16_=rng16_;
	rfidHeader->qValue_ = memory_;
	rfidHeader->trace_=trace_;
        ipHeader->daddr() = hdrip->saddr();
        ipHeader->dport() = hdrip->sport();
	ipHeader->saddr() = here_.addr_;
	ipHeader->sport() = here_.port_;
	send(pktret,0);
}
