create database vacina;
use vacina;
create table monitoramento(
id int primary key auto_increment,
temperatura decimal (5.1),
data_hora datetime default current_timestamp
);
insert into monitoramento (temperatura)values
('3.00'),
('7.80'),
('8.00'),
('11.50')
;
select * from monitoramento;
select
case when temperatura < 2 then concat('temperatura baixo - ',temperatura) 
when temperatura >8 then concat('temperatura elevada -',temperatura) else concat('temperatura casual -',temperatura)
end as 'temperatura em C' from monitoramento;