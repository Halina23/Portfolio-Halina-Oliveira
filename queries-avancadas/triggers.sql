-- ============================================
-- TRIGGERS — E-commerce PostgreSQL
-- Halina Oliveira | Portfolio
-- ============================================

-- TRIGGER 1: Verifica estoque antes da venda
-- Bloqueia o insert se não houver quantidade
-- suficiente disponível no estoque

CREATE OR REPLACE FUNCTION fn_verifica_estoque()
RETURNS TRIGGER AS $$
DECLARE
    estoque_disponivel INT;
BEGIN
    SELECT quantidade_disponivel
    INTO estoque_disponivel
    FROM estoque
    WHERE produto_id = NEW.produto_id;

    IF estoque_disponivel IS NULL THEN
        RAISE EXCEPTION 'Produto % não encontrado no estoque.', NEW.produto_id;
    END IF;

    IF NEW.quantidade > estoque_disponivel THEN
        RAISE EXCEPTION 'Estoque insuficiente para o produto %. Disponível: %, Solicitado: %',
            NEW.produto_id, estoque_disponivel, NEW.quantidade;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trg_verifica_estoque
BEFORE INSERT ON itens_venda
FOR EACH ROW
EXECUTE FUNCTION fn_verifica_estoque();


-- ============================================
-- TRIGGER 2: Baixa automática no estoque
-- Desconta a quantidade vendida do estoque
-- após cada item inserido em itens_venda

CREATE OR REPLACE FUNCTION fn_baixa_estoque()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE estoque
    SET 
        quantidade_disponivel = quantidade_disponivel - NEW.quantidade,
        ultima_atualizacao = CURRENT_TIMESTAMP
    WHERE produto_id = NEW.produto_id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trg_baixa_estoque
AFTER INSERT ON itens_venda
FOR EACH ROW
EXECUTE FUNCTION fn_baixa_estoque();
```

Commit com a mensagem:
```
Adiciona triggers de verificação e baixa de estoque
