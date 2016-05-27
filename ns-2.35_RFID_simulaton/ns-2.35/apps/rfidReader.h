
/*
 * rfidReader.h
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
 * File: Header File for a new 'RfidReader' Agent Class for the ns
 *       network simulator
 * Author: Rafael Perazzo Barbosa Mota (perazzo@ime.usp.br), Setembro 2012
 *
 */


//#ifndef ns_rfidReader_h
//#define ns_rfidReader_h

#include "agent.h"
#include "tclcl.h"
#include "packet.h"
#include "address.h"
#include "ip.h"

class RfidReaderAgent;

class RetransmitTimer : public TimerHandler {
        public:
                RetransmitTimer(RfidReaderAgent *a) : TimerHandler() { a_ = a; }
	protected:
                virtual void expire(Event *e);
                RfidReaderAgent *a_;
 };

class CollisionsTimer : public TimerHandler {
        public:
                CollisionsTimer(RfidReaderAgent *a) : TimerHandler() { a_ = a; }
	protected:
                virtual void expire(Event *e);
                RfidReaderAgent *a_;
 };


class RfidReaderAgent : public Agent {
public:
	RfidReaderAgent();
	virtual int command(int argc, const char*const* argv);
	virtual void recv(Packet*, Handler*);
	int id_; //reader id
	int tagEPC_; //last received EPC
	int singularization_; //deprecated
	int service_; //Use value 2
	int state_; //reader state
	int qValue_; //Q value
	int command_; //command type
	double Qfp_; 
	int memory_; //optional memory
	float rng16_; //received rng16
	int tag_; 
	int counter_; //receved packets counter
	double c_; //constanc c from Q algorithm
	int debug_; //View debug messages
	enum FLUXO {FLOW_RT=0, FLOW_TR=1,FLOW_RT_ACK=2}flow;
	enum SERVICE {SERVICE_NOSERVICE=0, SERVICE_TRACKING=1,SERVICE_STANDARD=2, SERVICE_EBTSA=3, SERVICE_EDFSA=4}service;
	enum SINGULARIZATION {SING_NOSINGULARIZATION=0, SING_RANDOMTIME=1}singularization;
	enum READER_STATE{RS_SELECT=0,RS_INVENTORY=1,RS_ACCESS=2}reader_state;
	enum READER_COMMAND{RC_QUERY=0,RC_QUERYADJUST=1, RC_QUERYREPLY=2,RC_ACK=3,RC_NAK=4, TC_REPLY=5, RC_EST=6, TR_EST_REPLY=7, RC_EST_FINISH=8, RC_SING=9}reader_command;
	void resend();
	void send_query(); //Initial command
	void query(int command, int slotNumber, int rep);
	void send_query_estimate(); //Initial estimate command
	void send_query_ajust(); //QueryAdjust
	void send_query_reply(); //QueryReply
	void start_sing(); 
	void reset_est();
	void start_est();
	void update_Q(int soma);
	void check_rebuttal();
	void finish(int dest); //Finish the Q Value Estimation
	void finish_start(int dest, int method);
	void send_query_reply_update_slot();
	void start_edfsa();
	void start_estimationDFSA();
	void resolve_collisions();
	void calculate_next_Q(int col, int suc, int method, int rep);
	int eomlee(float error, int col, int suc, int rep);
	double t2_; //slot time
	RetransmitTimer rs_timer_;
	CollisionsTimer col_timer_;
	int slotCounter_; //Total number of slots
	int collisions_; //Number of collision slots
	int idle_; //Number of idle slots
	int success_;
	int bigQ_; //Stores the biggest Q Value
	int total_; //Total number of collisions
	int uniqCounter_; //Slot time
	int session_; //Query counter
	int trace_; //1 - Simple trace 0 - Normal trace
	int tagIP_;
	int mechanism_; //QoS Mechanism - 0 off - 1 on
	float finalQ_; //Estimated Q Value
	int operation_; //0 - Singularization; 1 - Estimation
	int estCounter_; //Estimation counter
	int estConstant_; //Constant estimation - Default =3
	int slotEstCounter_;
	int rebuttal_;
	int temp_; //Partial collisions counter
	int tempSuc_; //Partial success counter
	int suc_; //Partial success counter
	int estMethod_; //Estimation Method. 0 - Lower Bound. 1 - Schoute. 2 - Eom-Lee. 3 - Mota. 4 - No method
	int iL_; //Initial frame size for eom-lee method
	FILE *fp;
	/* RESOLVE COLLISIONS VARS */
	int subQValue_;
	int subSlotNumber_;
	int slotNumber_;
	int backlog_; //0 - LB; 1 - Schoute; 2 - Eom-Lee; 3 - 2.45
	int initialFrameSize_; //Initial frame size for backlog_
	double frameMultiplier_; //Adjust initial frame size
	/* END COLLISIONS VARS */
};

//#endif // ns_rfidReader_h
