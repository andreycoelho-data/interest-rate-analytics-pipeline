CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_gerar_view_txjurosvporte`()
BEGIN
    -- Deleta a view se existir (DDL direto costuma funcionar em versões 8.0+)
    DROP VIEW IF EXISTS produtofinal.pf_txjurosvporte;
    
    -- Cria a view
    CREATE VIEW produtofinal.pf_taxajurosvporte AS 
    SELECT * FROM painel_tx.operacoes_processadasvporte;
END
