% N.B.: utilizzare lo stesso hotpoint per le connessioni di RasPI e del PC

clear; clc;

global data lastData;
N = 25;
data = {};

myMQTT = mqtt('tcp://192.168.1.7', ...
    'ClientID', 'MATLABClient', ...
    'Port', 1883 ...
);
mySub = subscribe(myMQTT, 'speaker');  %topic where data are received
mySub.Callback = @myMQTT_OnData;

for k = 1:N
    publish(myMQTT, 'listener', '779');
    %[message, time] = read(mySub)
    pause(1);
end;

disp(data);
x = [];

% On receive
function myMQTT_OnData(topic, msg)
    global data;

    jsondata = jsondecode(msg);
    
    refTemp=23;
    %% refTemp = queryVISAResource("KEYSIGHT_34465A", "MEAS:TEMP? TC, K", "%f"); % lettura temperatura di riferimento
    row = {datestr(now, 'yyyy-mm-ddTHH:MM:SS.FFF'), refTemp, jsondata.tH2O, jsondata.tOil};
    
    disp(row);
    xlsappend('test_.xls', row, 'Foglio1');
end