### 📊 E-commerce Analytics & DBA Project
Projeto focado em Inteligência de Negócios e Administração de Banco de Dados, simulando um ambiente corporativo real de e-commerce.


### 🎯 Impacto em Números
Faturamento Identificado: R$ 213.590,14

Oportunidade de Recuperação: R$ 523.680,45 (pedidos pendentes/cancelados)

Eficiência Operacional: Redução de ruptura de estoque via alertas automatizados.

### 🛠️ Stack Técnica
DBA: PostgreSQL (Joins, Subqueries, Views, Índices, Explain Analyze).

Automação: Python para inserção massiva de dados (Bulk Insert).

BI: Excel e Dashboards Estratégicos.

### 💻 Exemplos de Queries
Diagnóstico Financeiro SQL

SELECT SUM(valor_pago) AS prejuizo_total
FROM relatorio_compras 
WHERE status IN ('Cancelado', 'Pendente');
Alerta de Estoque Crítico (< 25 unidades)

SELECT p.nome, e.quantidade_disponivel, f.nome AS fornecedor
FROM produtos p
JOIN estoque e ON e.produto_id = p.produto_id
JOIN fornecedores f ON f.fornecedor_id = p.fornecedor_id
WHERE e.quantidade_disponivel < 25;

### 📄 Portfólio Completo
Confira a apresentação detalhada do projeto na pasta /docs deste repositório.

### 📫 Contato
www.linkedin.com/in/halina-oliveira | E-mail: halina.oliveira2021@gmail.com
