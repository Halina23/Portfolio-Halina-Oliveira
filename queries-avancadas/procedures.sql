-- ============================================
-- PROCEDURES — E-commerce PostgreSQL
-- Halina Oliveira | Portfolio
-- ============================================


-- PROCEDURE 1: Processar pedido completo
-- Insere venda + itens + pagamento em uma
-- única transação. Triggers validam o estoque.

CREATE OR REPLACE PROCEDURE sp_processar_pedido(
    p_cliente_id INT,
    p_canal_id INT,
    p_metodo_pagamento VARCHAR,
    p_itens JSON
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_venda_id INT;
    v_total NUMERIC(12,2) := 0;
    v_item JSON;
    v_produto_id INT;
    v_quantidade INT;
    v_preco NUMERIC(12,2);
BEGIN
    INSERT INTO vendas (data_venda, cliente_id, canal_id, status_venda)
    VALUES (CURRENT_TIMESTAMP, p_cliente_id, p_canal_id, 'Pago')
    RETURNING venda_id INTO v_venda_id;

    FOR v_item IN SELECT * FROM json_array_elements(p_itens)
    LOOP
        v_produto_id := (v_item->>'produto_id')::INT;
        v_quantidade := (v_item->>'quantidade')::INT;

        SELECT preco INTO v_preco
        FROM produtos
        WHERE produto_id = v_produto_id;

        INSERT INTO itens_venda (venda_id, produto_id, quantidade, preco_unitario)
        VALUES (v_venda_id, v_produto_id, v_quantidade, v_preco);

        v_total := v_total + (v_preco * v_quantidade);
    END LOOP;

    INSERT INTO pagamentos (venda_id, metodo_pagamento, valor_pago, status)
    VALUES (v_venda_id, p_metodo_pagamento, v_total, 'pago');

    RAISE NOTICE 'Pedido % processado com sucesso! Total: R$ %', v_venda_id, v_total;
END;
$$;


-- ============================================
-- PROCEDURE 2: Cancelar pedido
-- Cancela a venda, estorna o pagamento e
-- devolve os itens ao estoque

CREATE OR REPLACE PROCEDURE sp_cancelar_pedido(
    p_venda_id INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_status VARCHAR;
    v_item RECORD;
BEGIN
    SELECT status_venda INTO v_status
    FROM vendas
    WHERE venda_id = p_venda_id;

    IF v_status IS NULL THEN
        RAISE EXCEPTION 'Venda % não encontrada.', p_venda_id;
    END IF;

    IF v_status = 'Cancelado' THEN
        RAISE EXCEPTION 'Venda % já está cancelada.', p_venda_id;
    END IF;

    FOR v_item IN
        SELECT produto_id, quantidade
        FROM itens_venda
        WHERE venda_id = p_venda_id
    LOOP
        UPDATE estoque
        SET
            quantidade_disponivel = quantidade_disponivel + v_item.quantidade,
            ultima_atualizacao = CURRENT_TIMESTAMP
        WHERE produto_id = v_item.produto_id;
    END LOOP;

    UPDATE vendas
    SET status_venda = 'Cancelado'
    WHERE venda_id = p_venda_id;

    UPDATE pagamentos
    SET status = 'recusado'
    WHERE venda_id = p_venda_id;

    RAISE NOTICE 'Venda % cancelada com sucesso. Estoque revertido.', p_venda_id;
END;
$$;
```

Commit com a mensagem:
```
Adiciona procedures de processamento e cancelamento de pedido
