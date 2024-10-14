-- Cursor Atualiza Orçamento
DROP PROCEDURE IF EXISTS Atualiza_Orcamento;

DELIMITER //
CREATE PROCEDURE Atualiza_Orcamento ()
BEGIN

  -- Definição de variáveis utilizadas na Procedure
  DECLARE existe_mais_linhas INT DEFAULT 0;
  DECLARE Fun_Cod_Depto, Depto_Cod_Depto INT;
  DECLARE Val_Salario, Val_Orc, Tot_Orc FLOAT;

  -- Definição do cursor, que irá acessar registro a registro, departamentos onde o funcionário trabalha e seu salário
  --    e da tabela de departamentos, localizando o departamento e atualizando o valor do orçamento
  DECLARE FunCursor CURSOR FOR SELECT cd_depto, vl_salario, Vl_perc_Comissao FROM loc_funcionario;
  DECLARE DepCursor CURSOR FOR SELECT cd_depto, vl_Orc_Depto FROM loc_depto;

  -- Definição da variável de controle de looping do cursor
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET existe_mais_linhas=1;

  -- Abertura do cursor
  OPEN FunCursor;
  OPEN DepCursor;

  -- Looping de execução do cursor
  FunLoop: LOOP
     FETCH FunCursor INTO Fun_Cod_Depto, Val_Salario;

     -- Controle de existir mais registros na tabela. Em não existindo, sair do loop
     IF existe_mais_linhas = 1 THEN
        LEAVE FunLoop;
     END IF;

     -- Soma a kilometragem do registro atual com o total acumulado
     Update Loc_Depto 
        Set Vl_Orc_Depto = Vl_Orc_Depto + Val_Salario + Val_Salario * Vl_Perc_Comissao / 100
        Where cd_depto = Fun_Cod_Depto;

  -- Retorna para a primeira linha do loop
  END LOOP FunLoop;

  -- Setando a variável com o resultado final
  
  -- Fechar Cursor
  CLOSE FunCursor;
  CLOSE DepCursor;

  END //

  DELIMITER ;
  
  Call AtualizaOrcamento();
  
  Select Vl_Orc_Depto from loc_depto;
  
  Update loc_depto set Vl_Orc_depto = 0 where cd_depto >= 0;
