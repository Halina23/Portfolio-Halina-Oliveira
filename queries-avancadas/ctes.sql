-- ============================================
-- CTEs (Common Table Expressions)
-- E-commerce PostgreSQL
-- Halina Oliveira | Portfolio
-- ============================================


-- 1. Top 5 clientes por faturamento
WITH faturamento_clientes AS (
    SELECT
        c.nome AS cliente,
        SUM(p.valor_pago) AS total_gasto
    FROM pagamentos p
    JOIN vendas v ON v.venda_id = p.venda_id
    JOIN clientes c ON c.cliente_id = v.cliente_id
    WHERE p.status = 'pago'
    GROUP BY c.nome
)
SELECT
    cliente,
    total_gasto,
    RANK() OVER (ORDER BY total_gasto DESC) AS ranking
FROM faturamento_clientes
ORDER BY ranking
LIMIT 5;


-- 2. Produtos mais vendidos por categoria
WITH vendas_por_produto AS (
    SELECT
        pr.nome AS produto,
        cat.nome AS categoria,
        SUM(iv.quantidade) AS total_vendido,
        SUM(iv.quantidade * iv.preco_unitario) AS receita_gerada
    FROM itens_venda iv
    JOIN produtos pr ON pr.produto_id = iv.produto_id
    JOIN categorias cat ON cat.categoria_id = pr.categoria_id
    JOIN vendas v ON v.venda_id = iv.venda_id
    JOIN pagamentos p ON p.venda_id = v.venda_id
    WHERE p.status = 'pago'
    GROUP BY pr.nome, cat.nome
),
ranking_por_categoria AS (
    SELECT
        produto,
        categoria,
        total_vendido,
        receita_gerada,
        RANK() OVER (PARTITION BY categoria ORDER BY receita_gerada DESC) AS ranking
    FROM vendas_por_produto
)
SELECT *
FROM ranking_por_categoria
WHERE ranking = 1
ORDER BY receita_gerada DESC;


-- 3. Estados acima da média de faturamento
WITH faturamento_estados AS (
    SELECT
        e.sigla AS estado,
        SUM(p.valor_pago) AS faturamento
    FROM pagamentos p
    JOIN vendas v ON v.venda_id = p.venda_id
    JOIN clientes c ON c.cliente_id = v.cliente_id
    JOIN estados e ON e.estado_id = c.estado_id
    WHERE p.status = 'pago'
    GROUP BY e.sigla
),
media_geral AS (
    SELECT AVG(faturamento) AS media
    FROM faturamento_estados
)
SELECT
    f.estado,
    f.faturamento,
    ROUND(m.media, 2) AS media_geral,
    ROUND(f.faturamento - m.media, 2) AS diferenca
FROM faturamento_estados f
CROSS JOIN media_geral m
WHERE f.faturamento > m.media
ORDER BY f.faturamento DESC;


-- 4. Canais com maior taxa de cancelamento
WITH total_por_canal AS (
    SELECT
        cv.nome AS canal,
        COUNT(*) AS total_vendas
    FROM vendas v
    JOIN canais_venda cv ON cv.canal_id = v.canal_id
    GROUP BY cv.nome
),
cancelados_por_canal AS (
    SELECT
        cv.nome AS canal,
        COUNT(*) AS total_cancelados
    FROM vendas v
    JOIN canais_venda cv ON cv.canal_id = v.canal_id
    WHERE v.status_venda = 'Cancelado'
    GROUP BY cv.nome
)
SELECT
    t.canal,
    t.total_vendas,
    COALESCE(c.total_cancelados, 0) AS cancelados,
    ROUND(COALESCE(c.total_cancelados, 0) * 100.0 / t.total_vendas, 2) AS taxa_cancelamento_pct
FROM total_por_canal t
LEFT JOIN cancelados_por_canal c ON c.canal = t.canal
ORDER BY taxa_cancelamento_pct DESC;
