-- Manuten��o avan�ada de jobs bloqueados por mudan�a de IP ou nome do Servidor.
-- Selecionar tudo da tabela sysmaint_pans
select * from sysmaintplan_plans
-- Pegar o ID do job defeituoso
-- Colocar o ID nos campos abaixo e executar
-- Deletar o job de manuten��o bloqueado
go
delete from sysmaintplan_log where plan_id = '35AC712D-0281-43B3-BBA6-99B135215D9A'
go
delete from sysmaintplan_subplans where plan_id = '35AC712D-0281-43B3-BBA6-99B135215D9A'
go
delete from sysmaintplan_plans where id = '35AC712D-0281-43B3-BBA6-99B135215D9A'
go
