
function result = BBDD_Life_log_procesing(in_data)

[field_pulsera,field_colgante]=getDevicesFields(in_data);

%%%% Process disconnec event %%%%
%Bracelet
pulsera_discon=contains(in_data.(field_pulsera).LOGS.logs,'Disconnected');
pulsera_discon_timestamp=in_data.(field_pulsera).LOGS.timestamp(pulsera_discon);

%Pendant
colgante_discon=contains(in_data.(field_colgante).LOGS.logs,'Disconnected');
colgante_discon_timestamp=in_data.(field_colgante).LOGS.timestamp(colgante_discon);


%%%% Process connec event %%%%
%Bracelet
pulsera_con=contains(in_data.(field_pulsera).LOGS.logs,'Connected');
pulsera_con_timestamp=in_data.(field_pulsera).LOGS.timestamp(pulsera_con);

%Pendant
colgante_con=contains(in_data.(field_colgante).LOGS.logs,'Connected');
colgante_con_timestamp=in_data.(field_colgante).LOGS.timestamp(colgante_con);

%%%% Generate connection vector %%%%
%Bracelet
connect_vec_pulsera=double(pulsera_con|pulsera_discon);
connect_vec_pulsera_timestamp=in_data.(field_pulsera).LOGS.timestamp(connect_vec_pulsera);
connect_vec_pulsera(connect_vec_pulsera==0)=2;
connect_vec_pulsera(pulsera_discon)=0;
connect_vec_pulsera=connect_vec_pulsera(connect_vec_pulsera~=2);
%Pendant
connect_vec_colgante=double(colgante_con|colgante_discon);
connect_vec_colgante_timestamp=in_data.(field_colgante).LOGS.timestamp(connect_vec_colgante);
connect_vec_colgante(connect_vec_colgante==0)=2;
connect_vec_colgante(colgante_discon)=0;
connect_vec_colgante=connect_vec_colgante(connect_vec_colgante~=2);

result.pendant.connect_vec=connect_vec_colgante;
result.pendant.connect_vec_timestamp=connect_vec_colgante;

result.bracelet.connect_vec=connect_vec_pulsera;
result.bracelet.connect_vec_timestamp=connect_vec_pulsera;


figure
plot(connect_vec_pulsera_timestamp,connect_vec_pulsera);


figure
plot(connect_vec_colgante_timestamp,connect_vec_colgante);



end