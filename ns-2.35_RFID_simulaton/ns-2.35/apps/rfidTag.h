
/*
 * rfidTag.h
 * Copyright (C) 2000 by the University of Southern California
 * $Id: ping.h,v 1.5 2005/08/25 18:58:01 johnh Exp $
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
 * File: Header File for a new 'RfidTag' Agent Class for the ns
 *       network simulator
 * Author: Rafael Perazzo Barbosa Mota (perazzo@ime.usp.br), Setembro 2012
 *
 */


#ifndef ns_rfidTag_h
#define ns_rfidTag_h

#include "agent.h"
#include "tclcl.h"
#include "packet.h"
#include "address.h"
#include "ip.h"

class RfidTagAgent : public Agent {
public:
	RfidTagAgent();
	virtual int command(int argc, const char*const* argv);
	float RandomFloat(float min, float max);
	int RandomInt(int min, int max);
	void sendPacket(Packet* pkt, int c);
	virtual void recv(Packet*, Handler*);
	int id_; //Stores the last received READER ID
	int tagEPC_; //Tag EPC
	int service_; //Kind of service: Tracking, Standard,...
	int kill_; //Kill flag
	int time_; //Random wait time for send a packet
	int slot_; //Slot number
	float rng16_; //Random number
	int memory_; //Optional memory
	int memory2_; //Optional memory 2
	int state_; //Tag state
	int debug_;
	double seed_;
	int trace_;
	enum FLUXO {FLOW_RT=0, FLOW_TR=1,FLOW_RT_ACK=2}flow;
        enum SERVICE {SERVICE_NOSERVICE=0, SERVICE_TRACKING=1,SERVICE_STANDARD=2, SERVICE_EBTSA=3, SERVICE_EDFSA=4}service;
        enum SINGULARIZATION {SING_NOSINGULARIZATION=0, SING_RANDOMTIME=1}singularization;
	enum TAG_STATE{T_READY=0,T_ARBITRATE=1,T_REPLY=2,T_ACKNOWLEDGED=3,T_OPEN=4,T_SECURED=5,T_KILLED=6}tag_state;
        enum READER_COMMAND{RC_QUERY=0,RC_QUERYADJUST=1, RC_QUERYREPLY=2,RC_ACK=3,RC_NAK=4,TC_REPLY=5,RC_EST=6,TR_EST_REPLY=7, RC_EST_FINISH=8, RC_SING=9}reader_command;
	void updateSlot(); //0 - (2^Q)-1
	void updateSlot2(); //0 - Q
};

#endif // ns_rfidTag_h
