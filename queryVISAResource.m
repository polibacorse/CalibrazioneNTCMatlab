% queryVISAResource.m
% Interroga uno strumento GPIB restituendone la stringa identificativa (query *IDN?)
%
% uso: ans = queryVISAResource(VISA_Resource_Name, query, answerformat)

function a = queryVISAResource(VISARN, q, ansfmt)

delete(instrfind);
%delete(instrfind('Name', VISARN));
instr = visa('ni', VISARN);
fopen(instr);

a = query(instr, q, '%s', ansfmt);

fclose(instr);
delete(instr);
