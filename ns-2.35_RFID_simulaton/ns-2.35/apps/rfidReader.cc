
/*
 * rfidReader.cc
 * Copyright (C) 2000 by the University of Southern California
 * $Id: rfidReader.cc,v 1.8 2005/08/25 18:58:01 johnh Exp $
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
 * File: Code for a new 'RfidReader' Agent Class for the ns
 *       network simulator
 * Author: Rafael Perazzo Barbosa Mota (perazzo@ime.usp.br), Setembro 2012
 * Links para pagina e epcglobal 
 *Last update: 30/JAN/2012
 */

#include "rfidReader.h"
#include "rfidPacket.h"
#include <time.h>
#include <math.h>
static class RfidReaderClass : public TclClass {
public:
	RfidReaderClass() : TclClass("Agent/RfidReader") {}
	TclObject* create(int, const char*const*) {
		return (new RfidReaderAgent());
	}
} class_rfidReader;


RfidReaderAgent::RfidReaderAgent() : Agent(PT_RFIDPACKET), state_(0), command_(0),counter_(0),rs_timer_(this),col_timer_(this),slotCounter_(0), collisions_(0), idle_(0),success_(0),total_(0),uniqCounter_(1),session_(0),operation_(0), estCounter_(1), slotEstCounter_(0), rebuttal_(0)
{
	bind("packetSize_", &size_);
	bind("tagEPC_",&tagEPC_);
	bind("id_",&id_);
	bind("singularization_",&singularization_);
	bind("service_",&service_);
	bind("memory_",&memory_);
	bind("qValue_",&qValue_);
	bind("c_",&c_);
	bind("t2_",&t2_);
	bind("messages_",&debug_);
	bind("Qfp_",&Qfp_);
	bind("trace_",&trace_);
	bind("mechanism_",&mechanism_);
	bind("estConstant_",&estConstant_);
	bind("estMethod_",&estMethod_);
	bind("iL_",&iL_);
	bind("backlog_",&backlog_);
	bind("initialFrameSize_",&initialFrameSize_);
	bind("frameMultiplier_",&frameMultiplier_);
}

int RfidReaderAgent::command(int argc, const char*const* argv)
{
  if (argc == 2) {
    if (strcmp(argv[1], "query-tags") == 0) {
      resend();
      return (TCL_OK);
    }
    else if (strcmp(argv[1], "standard-query-tags") == 0) { //Q ALGORITHM
	operation_=0;	
	bigQ_=qValue_;
	collisions_=0;
	idle_=0;
	success_=0;
	session_++;
	slotCounter_=0;
	total_=0;
	uniqCounter_=0;
	send_query();
	rs_timer_.resched(t2_); //Wait for tags responses
	return (TCL_OK);
    }
    else if (strcmp(argv[1], "standard-with-estimation") == 0) { //ESTIMATION ONLY
	operation_=1;	
	estCounter_=1;
	bigQ_=qValue_;
	collisions_=0;
	idle_=0;
	success_=0;
	session_++;
	slotCounter_=0;
	total_=0;
	uniqCounter_=0;
	slotEstCounter_=0;
	rebuttal_=0;
	send_query_estimate();
	rs_timer_.resched(t2_); //Wait for tags responses
	return (TCL_OK);
    }
    else if (strcmp(argv[1], "edfsa-query") == 0) { //DFSA - Eom-Lee, Schoute and Lower Bound
	operation_=2;	
	estCounter_=1;
	bigQ_=qValue_;
	collisions_=0;
	idle_=0;
	success_=0;
	suc_=0;
	session_++;
	slotCounter_=0;
	total_=0;
	uniqCounter_=1; //Initial slot time
	slotEstCounter_=0;
	rebuttal_=0;
	query(RC_QUERY,uniqCounter_,0);
	rs_timer_.resched(t2_); //Wait for tags responses
	return (TCL_OK);
    }

    else if (strcmp(argv[1], "estimation-dfsa-query") == 0) { //Proposed Algortithm
	operation_=3;	
	estCounter_=1;
	bigQ_=qValue_;
	collisions_=0;
	idle_=0;
	success_=0;
	suc_=0;
	session_++;
	slotCounter_=0;
	total_=0;
	uniqCounter_=1; //Initial slot time
	slotEstCounter_=0;
	rebuttal_=0;
	fp = fopen("collisions.col","a");
	send_query_estimate();
	rs_timer_.resched(t2_); //Wait for tags responses
	return (TCL_OK);
    }

  }

  // If the command hasn't been processed by RfidReaderAgent()::command,
  // call the command() function for the base class
  return (Agent::command(argc, argv));
}



void RfidReaderAgent::recv(Packet* pkt, Handler*)
{
  // Access the IP header for the received packet:
  hdr_ip* hdrip = hdr_ip::access(pkt);
  // Access the RfidReader header for the received packet:
  hdr_rfidPacket* hdr = hdr_rfidPacket::access(pkt);
  if ((hdr->tipo_==FLOW_TR)&&(hdr->id_==id_)&&(hdr->service_==SERVICE_TRACKING)) { 
  	if (hdr->ack_==1) {
		//Send confirmation ACK
		Packet* pktret = allocpkt();
	        hdr_rfidPacket* rfidHeader = hdr_rfidPacket::access(pktret);
        	hdr_ip* ipHeader = hdr_ip::access(pktret);
	        rfidHeader->tagEPC_ = hdr->tagEPC_;
        	rfidHeader->id_ = hdr->id_;
	        rfidHeader->tipo_ = FLOW_RT_ACK;
		rfidHeader->service_=service_;
		rfidHeader->singularization_=singularization_;
        	//hdrIp->daddr() = IP_BROADCAST;
	        ipHeader->daddr() = hdrip->saddr();
        	ipHeader->dport() = hdrip->sport();
		send(pktret,0);
	}
  }
  else if ((hdr->tipo_==FLOW_TR)&&(hdr->id_==id_)&&(hdr->service_==SERVICE_STANDARD)) { //Q ALGORITHM
	if (hdr->command_!=TC_REPLY) { //SINGULARIZATION
		counter_++;
	}
	tagEPC_=hdr->tagEPC_;
	tagIP_=hdrip->saddr();
	rng16_=hdr->rng16_;
	if (hdr->command_==TC_REPLY) { //UNIQUE TAG RESPONSE
		if (debug_==1) printf("Tag [%d] identified\n",hdr->tagEPC_);
		counter_=0;
	}

  }
  else if ((hdr->tipo_==FLOW_TR)&&(hdr->id_==id_)&&(hdr->service_==SERVICE_EBTSA)) { //EBTSA
	if (hdr->command_==TR_EST_REPLY) { //SINGULARIZATION
		counter_++;
	}
	tagEPC_=hdr->tagEPC_;
	tagIP_=hdrip->saddr();
	rng16_=hdr->rng16_;
  }

  else if ((hdr->tipo_==FLOW_TR)&&(hdr->id_==id_)&&(hdr->service_==SERVICE_EDFSA)) { //EDFSA
	if (hdr->command_==TC_REPLY) { //SINGULARIZATION
		counter_++;
	}
	tagEPC_=hdr->tagEPC_;
	tagIP_=hdrip->saddr();
	rng16_=hdr->rng16_;
  }  

  else if(hdr->tipo_==FLOW_RT){
	if (debug_) printf("Reader (unknown) received REPLY from (%i)\n",hdr->tagEPC_);
  }
  Packet::free(pkt);
  return;
}
void RfidReaderAgent::resend() {
	Packet* pkt = allocpkt(); 
        //Create network header
        hdr_ip* ipHeader = HDR_IP(pkt);
        //Create RFID header
        hdr_rfidPacket *rfidHeader = hdr_rfidPacket::access(pkt);
        //Prepating headers
        rfidHeader->id_ = id_; //Reader ID
        rfidHeader->tipo_ = FLOW_RT; //flow direction
        rfidHeader->singularization_ = singularization_; //imediatly reply or random time reply
        rfidHeader->service_=service_;
        ipHeader->daddr() = IP_BROADCAST; //Destination: broadcast
        ipHeader->dport() = ipHeader->sport();
        ipHeader->saddr() = here_.addr_; //Source: reader ip
        ipHeader->sport() = here_.port_;
	//Sends the packet
        send(pkt, (Handler*) 0);
}

void RfidReaderAgent::query(int command, int slotNumber, int rep) {

	Packet* pkt = allocpkt(); 
        //Create network header
        hdr_ip* ipHeader = HDR_IP(pkt);
        //Create RFID header
        hdr_rfidPacket *rfidHeader = hdr_rfidPacket::access(pkt);
        //Prepating headers
        rfidHeader->id_ = id_; //Reader ID
        rfidHeader->tipo_ = FLOW_RT; //flow direction
        rfidHeader->singularization_ = singularization_; //imediatly reply or random time reply
        rfidHeader->service_=service_;
	rfidHeader->command_=command;
	if (rep==0)	
		rfidHeader->qValue_=qValue_;
	else rfidHeader->qValue_=subQValue_;
	rfidHeader->tagEPC_=IP_BROADCAST;
	rfidHeader->slotCounter_=slotCounter_;
	rfidHeader->colCounter_=collisions_;
	rfidHeader->idlCounter_=idle_;
	rfidHeader->sucCounter_=success_;
	rfidHeader->session_=session_;
	rfidHeader->trace_=trace_;
	rfidHeader->reply_=rep; //To resolve local collisions
	rfidHeader->slotNumber_=slotNumber;
	rfidHeader->mechanism_=mechanism_;
        ipHeader->daddr() = IP_BROADCAST; //Destination: broadcast
        ipHeader->saddr() = here_.addr_; //Source: reader ip
        ipHeader->sport() = here_.port_;
        //Sends the packet
        send(pkt, (Handler*) 0);

}

void RfidReaderAgent::send_query() {

	query(RC_QUERY,0,0);

}

void RfidReaderAgent::finish(int dest) {

	Packet* pkt = allocpkt(); 
        //Create network header
        hdr_ip* ipHeader = HDR_IP(pkt);
        //Create RFID header
        hdr_rfidPacket *rfidHeader = hdr_rfidPacket::access(pkt);
        //Prepating headers
        rfidHeader->id_ = id_; //Reader ID
        rfidHeader->tipo_ = FLOW_RT; //flow direction
        rfidHeader->singularization_ = singularization_; //imediatly reply or random time reply
        rfidHeader->service_=service_;
	rfidHeader->command_=RC_EST_FINISH;
	rfidHeader->qValue_=round(finalQ_);
	rfidHeader->tagEPC_=dest;
	rfidHeader->slotCounter_=slotEstCounter_;
	rfidHeader->colCounter_=collisions_;
	rfidHeader->idlCounter_=idle_;
	rfidHeader->sucCounter_=success_;
	rfidHeader->session_=session_;
	rfidHeader->trace_=trace_;
	rfidHeader->mechanism_=mechanism_;
        ipHeader->daddr() = dest; //Destination: broadcast
        ipHeader->saddr() = here_.addr_; //Source: reader ip
        ipHeader->sport() = here_.port_;
        //Sends the packet
        send(pkt, (Handler*) 0);
	//Packet::free(pkt);

}

void RfidReaderAgent::finish_start(int dest, int method) {
	if (method==4) {
		finish(dest);
	}
	else if (method==3) {
		//printf("Q = %d\nSlots = %d\n",qValue_,slotEstCounter_);
		//Proposed Algorithm Start
		service_=4;
		estMethod_=backlog_;
		operation_=4;
		slotCounter_=slotEstCounter_;
		qValue_=round(pow(2,qValue_)*frameMultiplier_);
		//printf("Iniciando contagem em: %d\n",slotCounter_);
		//printf("Estimativa: (%d)\n",qValue_);
		query(RC_QUERY,uniqCounter_,0);
		rs_timer_.resched(t2_); //Wait for tags responses
	}
}

void RfidReaderAgent::send_query_estimate() {

	Packet* pkt = allocpkt(); 
        //Create network header
        hdr_ip* ipHeader = HDR_IP(pkt);
        //Create RFID header
        hdr_rfidPacket *rfidHeader = hdr_rfidPacket::access(pkt);
        //Prepating headers
        rfidHeader->id_ = id_; //Reader ID
        rfidHeader->tipo_ = FLOW_RT; //flow direction
        rfidHeader->singularization_ = singularization_; //imediatly reply or random time reply
        rfidHeader->service_=service_;
	rfidHeader->command_=RC_EST;
	rfidHeader->qValue_=qValue_;
	rfidHeader->tagEPC_=IP_BROADCAST;
	rfidHeader->slotCounter_=slotCounter_;
	rfidHeader->colCounter_=collisions_;
	rfidHeader->idlCounter_=idle_;
	rfidHeader->sucCounter_=success_;
	rfidHeader->session_=session_;
	rfidHeader->trace_=trace_;
	rfidHeader->mechanism_=mechanism_;
        ipHeader->daddr() = IP_BROADCAST; //Destination: broadcast
        ipHeader->saddr() = here_.addr_; //Source: reader ip
        ipHeader->sport() = here_.port_;
        //Sends the packet
        send(pkt, (Handler*) 0);
	//Packet::free(pkt);

}

void RfidReaderAgent::send_query_ajust() {

        Packet* pkt = allocpkt();
        //Create network header
        hdr_ip* ipHeader = HDR_IP(pkt);
        //Create RFID header
        hdr_rfidPacket *rfidHeader = hdr_rfidPacket::access(pkt);
        //Prepating headers
        rfidHeader->id_ = id_; //Reader ID
        rfidHeader->tipo_ = FLOW_RT; //flow direction
        rfidHeader->singularization_ = singularization_; //imediatly reply or random time reply
        rfidHeader->service_=service_;
	rfidHeader->command_=RC_QUERYADJUST;
        rfidHeader->qValue_=qValue_;
	rfidHeader->tagEPC_=IP_BROADCAST;
	rfidHeader->slotCounter_=slotCounter_;
	rfidHeader->colCounter_=collisions_;
        rfidHeader->idlCounter_=idle_;
        rfidHeader->sucCounter_=success_;
	rfidHeader->session_=session_;
	rfidHeader->trace_=trace_;
	rfidHeader->mechanism_=mechanism_;
        if (debug_) printf("New qValue=%i\n",rfidHeader->qValue_);
	ipHeader->daddr() = IP_BROADCAST; //Destination: broadcast
        ipHeader->dport() = ipHeader->sport();
        ipHeader->saddr() = here_.addr_; //Source: reader ip
        ipHeader->sport() = here_.port_;
        //Sends the packet
        send(pkt, (Handler*) 0);
}

void RfidReaderAgent::send_query_reply() {

        Packet* pkt = allocpkt(); 
        //Create network header
	hdr_ip* ipHeader = HDR_IP(pkt);
        //Create RFID header
	hdr_rfidPacket *rfidHeader = hdr_rfidPacket::access(pkt);
        //Prepating headers
        rfidHeader->id_ = id_; //Reader ID
        rfidHeader->tipo_ = FLOW_RT; //flow direction
        rfidHeader->singularization_ = singularization_; //imediatly reply or random time reply
        rfidHeader->service_=service_;
	rfidHeader->command_=RC_QUERYREPLY;
        rfidHeader->qValue_=qValue_;
	rfidHeader->tagEPC_=tagEPC_;
	rfidHeader->rng16_=rng16_;
	rfidHeader->slotCounter_=slotCounter_;
	rfidHeader->colCounter_=collisions_;
        rfidHeader->idlCounter_=idle_;
        rfidHeader->sucCounter_=success_;
	rfidHeader->session_=session_;
	rfidHeader->trace_=trace_;
	rfidHeader->mechanism_=mechanism_;
        //ipHeader->daddr() = IP_BROADCAST; //Destination: broadcast
        ipHeader->daddr() = tagIP_; //Destination: Identified tag
        ipHeader->saddr() = here_.addr_; //Source: reader ip
        //Sends the packet
	send(pkt, (Handler*) 0);
}

void RfidReaderAgent::send_query_reply_update_slot() {

        Packet* pkt = allocpkt(); 
        //Create network header
        hdr_ip* ipHeader = HDR_IP(pkt);
        //Create RFID header
        hdr_rfidPacket *rfidHeader = hdr_rfidPacket::access(pkt);
        //Prepating headers
        rfidHeader->id_ = id_; //Reader ID
        rfidHeader->tipo_ = FLOW_RT; //flow direction
        rfidHeader->singularization_ = singularization_; //imediatly reply or random time reply
        rfidHeader->service_=service_;
        rfidHeader->command_=RC_QUERYREPLY;
        rfidHeader->qValue_=qValue_;
        rfidHeader->tagEPC_=IP_BROADCAST;
	rfidHeader->slotCounter_=slotCounter_;
	rfidHeader->colCounter_=collisions_;
        rfidHeader->idlCounter_=idle_;
        rfidHeader->sucCounter_=success_;
	rfidHeader->session_=session_;
	rfidHeader->trace_=trace_;
	rfidHeader->mechanism_=mechanism_;
        ipHeader->daddr() = IP_BROADCAST; //Destination: broadcast
        ipHeader->saddr() = here_.addr_; //Source: reader ip
        //Sends the packet
        send(pkt, (Handler*) 0); 
}

void RfidReaderAgent::start_sing() {
	 slotCounter_++;
	 if (counter_==0) {
		if (debug_) printf("NO TAGS RESPONSES!!(%d)\n",id_);
                idle_++;
		Qfp_=fmax(0,Qfp_ - c_);
                if (Qfp_>15) {
                        Qfp_=15;
                }

		if (qValue_!=-1) {
			qValue_=round(Qfp_);
			if (qValue_>=bigQ_) bigQ_=qValue_;
			//else if((bigQ_-2)==qValue_){printf("Diminuindo(%d)(%d)...\n",total_,uniqCounter_);}
	                if (qValue_==-1) return;

		}
                if (debug_) printf("Qfp=%1f - Q=%d\n",Qfp_,qValue_);
                //send_query_ajust(); //MODIFIQUEI AQUI
		if (qValue_>0) {
			send_query_ajust();
			rs_timer_.resched(t2_);
		}
		else if (qValue_==0) {
			qValue_--;
			send_query_ajust();
			rs_timer_.resched(t2_);
		}
		else if (qValue_==-1) {
			//printf("Slots number: %d\n",slotCounter_);
			//printf("Bigest Q: %d\n",bigQ_);
			//printf("Total collision slots: %d\n",total_);
			return;
		}
        }
        if (counter_==1) {
                if (debug_) printf("JUST ONE TAG REPLY!!\n");
		//printf("Collisons slots: %d\n",collisions_);
		//printf("Idle slots: %d\n",idle_);
		//printf("Provavalmente restam ainda %.0f tags\n",pow(2,qValue_)-1);
		uniqCounter_++;
		success_++;
		total_=total_+collisions_;
		counter_=0;
		//idle_=0;
		//collisions_=0;
		send_query_reply();
		send_query_reply_update_slot();
		rs_timer_.resched(t2_);

        }
	if (counter_>1) {
      		//printf("Collisions: %d\n",counter_);
		//total_=total_+counter_;
		if (debug_) printf("COLLISION - (%d) tags replied\n",counter_);
                collisions_++;
		Qfp_=fmin(15,Qfp_ + c_);
                if (Qfp_<0) {
                        Qfp_=0;
                }
                qValue_=round(Qfp_);
		if (qValue_>=bigQ_) {
			bigQ_=qValue_;
		}
		//else if((bigQ_-2)==qValue_){printf("Diminuindo(%d)(%d)...\n",total_,uniqCounter_);}
                if (debug_) printf("Qfp=%1f - Q=%d\n",Qfp_,qValue_);
                counter_=0;
		send_query_ajust();
		if (qValue_==15) return;
		else
			rs_timer_.resched(t2_);
        }
}

void RfidReaderAgent::reset_est() { 
	estCounter_=1;
	collisions_=0;
	idle_=0;
	success_=0;
	counter_=0;
}

void RfidReaderAgent::update_Q(int soma) { //If soma=0 (-) if soma=1 (+) otherwise do not change
	
	if (soma==0) {
		Qfp_=Qfp_-c_;
	}
	else if (soma==1){
		Qfp_=Qfp_+c_;
		if (Qfp_>15) Qfp_=4;
	}
	qValue_=round(Qfp_);
	//printf("Q mudou para: %d\n",qValue_);	
}

void RfidReaderAgent::check_rebuttal() {
	if ((finalQ_==Qfp_)) { //Estimated Q found!
		reset_est();		
		finish_start(IP_BROADCAST,estMethod_);		
		//printf("O numero estimado de tags eh: %.0f(%.0f)\n",pow(2,round(finalQ_)),round(finalQ_));
		//printf("Total de slots: %d\n",slotEstCounter_);
	}
	else { //Restart									
		Qfp_=finalQ_;
		qValue_=round(Qfp_);
		reset_est();
		update_Q(2);
		rebuttal_=0;
		send_query_estimate(); //Restart
		rs_timer_.resched(t2_);					
	}
}

void RfidReaderAgent::start_est() {
	slotEstCounter_++;
	if (counter_==0) { //idle
		idle_++;
        }
        if (counter_==1) { //success
                success_++;
		send_query_reply();
        }
	if (counter_>1) { //collision
      		collisions_++;
        }
	estCounter_++;
	if (estCounter_==(estConstant_+1)) {
		//printf("Col: %d\n Idl: %d\n Suc: %d\n",collisions_,idle_,success_);		
		if ((idle_==estConstant_)) { //All idle			
			if (rebuttal_==0) {						
				reset_est(); //decrease Q				
				update_Q(0);
				send_query_estimate(); //Restart
				rs_timer_.resched(t2_);	
			}
			else {
				update_Q(0);	
				check_rebuttal();
			}
		}
		else if ((collisions_==estConstant_)) { //All collisions
			//printf("Entrou collisions!!\n");			
			if (rebuttal_==0) {			
				reset_est(); //decrease Q				
				update_Q(1);
				send_query_estimate();	//Restart
				rs_timer_.resched(t2_);
			}
			else {
				update_Q(1);
				check_rebuttal();
			}
		}
		else if ((collisions_<estConstant_)&&(idle_<estConstant_)) {
			//printf("Entrou outro!!\n");	
			if (rebuttal_==0) {						
				finalQ_=Qfp_;
				//Rebuttal 
				rebuttal_++;
				reset_est();
				update_Q(2);
				send_query_estimate();	//Restart
				rs_timer_.resched(t2_);
			}
			else {
				check_rebuttal();
			}

		}
	}
	else {
		send_query_estimate();	
		rs_timer_.resched(t2_);
	}
}

void RfidReaderAgent::start_edfsa() {
	slotCounter_++;
	uniqCounter_++; //next slot
	if (counter_==0) { //IDLE
		//printf("Slot %d : IDLE\n",uniqCounter_-1);
		idle_++;
        }
        if (counter_==1) { //SUCCESS
                //printf("Slot %d : SUCCESS(%d)\n",uniqCounter_-1,tagEPC_);
		success_++;
		suc_++;
		send_query_reply();
        }
	if (counter_>1) { //COLLISION
      		//printf("Slot %d : COLLISION\n",uniqCounter_-1);
		collisions_++;
        }
	if (uniqCounter_<=qValue_) {
		counter_=0;		
		query(RC_SING,uniqCounter_,0);
		rs_timer_.resched(t2_);
	}
	else { //Next frame	
		temp_=collisions_;
		tempSuc_=suc_;
		collisions_=0;
		suc_=0;
		idle_=0;
		counter_=0;
		uniqCounter_=1;
		calculate_next_Q(temp_,tempSuc_,estMethod_,0);				
	}
}

void RfidReaderAgent::start_estimationDFSA() {
	slotCounter_++;
	uniqCounter_++; //next slot
	//printf("Slot numero (%d)\n",uniqCounter_-1);
	if (counter_==0) { //IDLE
		//printf("Slot %d : IDLE\n",uniqCounter_-1);
		idle_++;
        }
        if (counter_==1) { //SUCCESS
                //printf("Slot %d : SUCCESS\n",uniqCounter_-1);
		success_++;
		suc_++;
		send_query_reply();
        }
	if (counter_>1) { //COLLISION
      		//printf("Colisoes: %d\n", counter_);
		fprintf(fp,"%d\n",counter_);
		collisions_++;
		//RESOLVE COLLISIONS
		//printf("Resolvendo colisao do slot (%d)\n",uniqCounter_-1);		
		slotNumber_=uniqCounter_-1;
		uniqCounter_=qValue_+1;
		subQValue_=initialFrameSize_;
		subSlotNumber_=1;
		counter_=0;
		collisions_=0;
		suc_=0;
		query(RC_QUERY,subSlotNumber_,slotNumber_); //First slot
		col_timer_.resched(t2_);
        }
	if (uniqCounter_<=qValue_) {
		counter_=0;
		query(RC_SING,uniqCounter_,0);
		rs_timer_.resched(t2_);
	}
}

/**
Resolve collisions slots as soon as they occurs
*/
void RfidReaderAgent::resolve_collisions() {
	slotCounter_++;
	subSlotNumber_++;
	//printf("SubQValue: (%d)\n",subQValue_);
	if (counter_==0) { //IDLE
		//printf("SubSlot %d : IDLE\n",subSlotNumber_-1);
		idle_++;
        }
        if (counter_==1) { //SUCCESS
                //printf("SubSlot %d : SUCCESS(%d)\n",subSlotNumber_-1,tagEPC_);
		success_++;
		suc_++;
		send_query_reply();
        }
	if (counter_>1) { //COLLISION
      		//printf("SubSlot %d : COLLISION\n",subSlotNumber_-1);
		collisions_++;
        }
	if (subSlotNumber_<=subQValue_) {
		counter_=0;
		//printf("Proximo slot: %d\n",subSlotNumber_);		
		query(RC_SING,subSlotNumber_,slotNumber_); 
		col_timer_.resched(t2_);
	}
	else { //Next frame	
		temp_=collisions_;
		tempSuc_=suc_;
		collisions_=0;
		suc_=0;
		idle_=0;
		counter_=0;
		subSlotNumber_=1;
		calculate_next_Q(temp_,tempSuc_,estMethod_,slotNumber_);				
	}
}

void RfidReaderAgent::calculate_next_Q(int col, int suc, int method, int rep) {

	if (col>0) {
		if (method==0) { //LOWER BOUND
			
			if (rep==0) {	//STANDARD DFSA		
				qValue_=(2*col);				
				query(RC_QUERY,uniqCounter_,rep);
				rs_timer_.resched(t2_); //Wait for tags responses			
			}
			else { //Proposed Algorithm
				subQValue_=2*col;				
				query(RC_QUERY,subSlotNumber_,rep);
				col_timer_.resched(t2_); //Wait for tags responses	
			}
		}
		else if (method==1) { //SCHOUTE
			
			if (rep==0) {	//STANDARD DFSA
				qValue_=round(2.39*col);
				query(RC_QUERY,uniqCounter_,rep);
				rs_timer_.resched(t2_); //Wait for tags responses			
			}
			else { //Proposed Algorithm				
				subQValue_=round(2.39*col);				
				query(RC_QUERY,subSlotNumber_,rep);
				col_timer_.resched(t2_); //Wait for tags responses	
			}
		}
		else if (method==2) { //EOM-LEE
                        
                        if (rep==0) {	//STANDARD DFSA		
				qValue_=eomlee(0.0001,col,suc,0); 				
				query(RC_QUERY,uniqCounter_,rep);
				rs_timer_.resched(t2_); //Wait for tags responses			
			}
			else { //Proposed Algorithm
				subQValue_=eomlee(0.0001,col,suc,rep); 				
				//printf("Calculando eom-lee proposed (%d) (rep: %d)...\n",subQValue_,rep);
				query(RC_QUERY,subSlotNumber_,rep);
				col_timer_.resched(t2_); //Wait for tags responses	
			}
                }
		else if (method==3) { //2.45

                        if (rep==0) {   //STANDARD DFSA         
                                qValue_=2.45*col;
                                query(RC_QUERY,uniqCounter_,rep);
                                rs_timer_.resched(t2_); //Wait for tags responses
                        }
                        else { //Proposed Algorithm
                                subQValue_=2.45*col; 
                                //printf("Calculando eom-lee proposed (%d) (rep: %d)...\n",subQValue_,rep);
                                query(RC_QUERY,subSlotNumber_,rep);
                                col_timer_.resched(t2_); //Wait for tags responses      
                        }
                }
		else if (method==4) { //2.62

                        if (rep==0) {   //STANDARD DFSA         
                                qValue_=2.62*col;
                                query(RC_QUERY,uniqCounter_,rep);
                                rs_timer_.resched(t2_); //Wait for tags responses
                        }
                        else { //Proposed Algorithm
                                subQValue_=2.62*col; 
                                //printf("Calculando eom-lee proposed (%d) (rep: %d)...\n",subQValue_,rep);
                                query(RC_QUERY,subSlotNumber_,rep);
                                col_timer_.resched(t2_); //Wait for tags responses      
                        }
                }



	}
	else {
		if (rep!=0) { //Resolving collisions
			uniqCounter_=slotNumber_+1;
			counter_=0;	
			//printf("Voltando para o DFSA no slot (%d)\n",uniqCounter_);
			query(RC_SING,uniqCounter_,0);			
			rs_timer_.resched(t2_);
		}
		else { //Normal DFSA operation
			
		}
	}

}

int RfidReaderAgent::eomlee(float error, int col, int suc, int rep) {
	float temp, bprox;
	float y1 = 2, yprox;
	float backlog;
	//printf("Colidiram %d tags\n",col);
	//printf("Sucesso em %d tags\n",suc);
	do {
        	if (rep==0) bprox = (qValue_)/((y1*(float)col)+(float)suc);
		else bprox = (subQValue_)/((y1*(float)col)+(float)suc);
        	yprox = (1-exp((-1)/bprox))/(bprox*(1-(1+ 1/bprox)*exp((-1)/bprox)));
        	backlog = yprox*col;
        	temp = y1;
        	y1 = yprox;
        } while (fabs(y1-temp)>error);
	return (round(backlog));
}

void RetransmitTimer::expire(Event *e) {
	if (a_->operation_==0) { //Singularization	
		a_->start_sing();
	}
	else if ((a_->operation_==1)||(a_->operation_==3)) { //Estimation and singularization
		a_->start_est();
	}
	else if (a_->operation_==2) { //Estimation and singularization
		a_->start_edfsa();
	}
	else if (a_->operation_==4) { //Estimation and singularization
		a_->start_estimationDFSA();
	}
}

void CollisionsTimer::expire(Event *e) {
	a_->resolve_collisions();
}

