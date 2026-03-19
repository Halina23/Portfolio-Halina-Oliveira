SELECT DISTINCT status FROM pagamentos;

-- =============================
-- Receita por canal com participação percentual no faturamento total
-- =============================
SELECT
    cv.nome AS canal_venda,
    SUM(p.valor_pago) AS receita_total,
    ROUND(SUM(p.valor_pago) * 100.0 / SUM(SUM(p.valor_pago)) OVER (), 2) AS participacao_pct
FROM pagamentos p
JOIN vendas v ON v.venda_id = p.venda_id
JOIN canais_venda cv ON cv.canal_id = v.canal_id
WHERE p.status = 'pago'
GROUP BY cv.nome
ORDER BY receita_total DESC;

-- =============================
-- Ranking de estados por faturamento
-- =============================

SELECT
    e.sigla AS estado,
    SUM(p.valor_pago) AS faturamento,
    RANK() OVER (ORDER BY SUM(p.valor_pago) DESC) AS ranking
FROM pagamentos p
JOIN vendas v ON v.venda_id = p.venda_id
JOIN clientes c ON c.cliente_id = v.cliente_id
JOIN estados e ON e.estado_id = c.estado_id
WHERE p.status = 'pago'
GROUP BY e.sigla
ORDER BY ranking;

-- =============================
-- Ticket médio por estado comparado à média geral
-- =============================


SELECT
    e.sigla AS estado,
    ROUND(AVG(p.valor_pago), 2) AS ticket_medio_estado,
    ROUND(AVG(AVG(p.valor_pago)) OVER (), 2) AS media_geral,
    ROUND(AVG(p.valor_pago) - AVG(AVG(p.valor_pago)) OVER (), 2) AS diferenca_da_media
FROM pagamentos p
JOIN vendas v ON v.venda_id = p.venda_id
JOIN clientes c ON c.cliente_id = v.cliente_id
JOIN estados e ON e.estado_id = c.estado_id
WHERE p.status = 'pago'
GROUP BY e.sigla
ORDER BY ticket_medio_estado DESC;


-- =============================
-- Evolução mensal com crescimento em relação ao mês anterior
-- =============================

SELECT
    TO_CHAR(v.data_venda, 'YYYY-MM') AS mes,
    SUM(p.valor_pago) AS faturamento_mes,
    LAG(SUM(p.valor_pago)) OVER (ORDER BY TO_CHAR(v.data_venda, 'YYYY-MM')) AS faturamento_mes_anterior,
    ROUND(
        (SUM(p.valor_pago) - LAG(SUM(p.valor_pago)) OVER (ORDER BY TO_CHAR(v.data_venda, 'YYYY-MM')))
        * 100.0 / LAG(SUM(p.valor_pago)) OVER (ORDER BY TO_CHAR(v.data_venda, 'YYYY-MM')), 2
    ) AS crescimento_pct
FROM pagamentos p
JOIN vendas v ON v.venda_id = p.venda_id
WHERE p.status = 'pago'
GROUP BY TO_CHAR(v.data_venda, 'YYYY-MM')
ORDER BY mes;
