
/*
  this example shows how to use readWriteMultipleRegisters
*/

// configure spi
local spi = hardware.spi0;
spi.configure(CLOCK_IDLE_LOW | MSB_FIRST | USE_CS_L, 1000);

// instantiate a modbus object
local modbus = ModbusTCP(spi, hardware.pinXC, null, hardware.pinXA);

// the network setting
local networkSettings = {
    "gatewayIP"  : [192, 168, 201, 1],
    "subnet"     : [255, 255, 255, 0],
    "sourceIP"   : [192, 168, 1, 30]
};

// the device address and port
local connectionSettings = {
    "destIP"     : [192, 168, 1, 90],
    "destPort"   : [0x01, 0xF6]
};

// open the connection
modbus.connect(networkSettings, connectionSettings, function(error, conn){
    if (error) {
        return server.log(error);
    }
    // read and write multiple registers in one go , with read run before write
    modbus.readWriteMultipleRegisters(0x0A, 2, 0x0A, 2, [28,88], function(error, result){
        if (error) {
            server.error(error);
        } else {
            foreach (index, value in result) {
                server.log(format("Index : %d, value : %d",index,value));
            }
        }
    });
});
