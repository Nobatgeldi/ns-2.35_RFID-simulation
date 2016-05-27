//rfidPacket.cc
#include "rfidPacket.h"

int hdr_rfidPacket::offset_;
static class RfidPacketHeaderClass : public PacketHeaderClass {
public:
	RfidPacketHeaderClass() : PacketHeaderClass("PacketHeader/RfidPacket", 
					      sizeof(hdr_rfidPacket)) {
		bind_offset(&hdr_rfidPacket::offset_);
	}
} class_rfidPackethdr;
