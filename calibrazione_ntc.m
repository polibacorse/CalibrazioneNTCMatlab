% N.B.: utilizzare lo stesso hotpoint per le connessioni di RasPI e del PC

global data lastData;
N = 25;
data = {};

myMQTT = mqtt('tcp://192.168.43.96', ...
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

    refTemp = queryVISAResource("KEYSIGHT_34465A", "MEAS:TEMP? TC, K", "%f"); % lettura temperatura di riferimento
    row = {datestr(now, 'yyyy-mm-ddTHH:MM:SS.FFF'), refTemp, msg};
    disp(row);
    xlsappend('test_.xls', row, 'Foglio1');
end
