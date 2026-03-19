### 👩‍💻 Halina Oliveira | Portfólio de Análise de Dados

Estudante de Banco de Dados com foco em análise de dados, SQL e Python.
Transformo dados em **insights de negócio e apoio à decisão** utilizando SQL, Python e Power BI.
### 🚀 Sobre este portfólio

Este repositório reúne meus principais projetos de análise de dados, onde aplico na prática:

- Extração e manipulação de dados com SQL

- Tratamento e análise com Python (Pandas)

- Visualização de dados com Matplotlib / Power BI

- Estruturação de pipelines de dados

### 📊 Projeto em destaque: Análise de Vendas
### 🎯 Objetivo

Analisar dados de vendas para identificar padrões, desempenho por canal e oportunidades de crescimento.

### ⚙️ Tecnologias utilizadas

- PostgreSQL

- Python (Pandas, Matplotlib)

- Google Colab / VS Code

### 🔄 Pipeline do projeto

- Extração de dados via SQL

- Limpeza e tratamento com Pandas

- Análise exploratória (EDA)

- Criação de métricas de negócio

- Visualização de dados

### 📈 Principais análises

- Faturamento total

- Receita por canal de vendas

- Evolução mensal de vendas

- Volume de vendas por canal

### 💡 Insights gerados

- Marketplace lidera o faturamento

- Site é o segundo canal mais relevante

- Loja física com menor participação → oportunidade de crescimento digital

- Picos de vendas em setembro e novembro (sazonalidade)

- ### ✅ Resultados
A análise permitiu identificar os principais canais de receita e padrões de vendas, possibilitando:

- Melhor direcionamento de estratégias comerciais  
- Identificação de oportunidades de crescimento digital  
- Apoio à tomada de decisão baseada em dados 

### 🔍 Exemplo de análise — Receita por canal de vendas

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

| Canal       | Receita       | Participação |
|-------------|---------------|------------- |
| Marketplace | R$ 1.887.647  | 51,13%       |
| Site        | R$ 1.619.317  | 43,86%       | 
| Loja Física | R$ 184.854    | 5,01%        |


### 📊 Dashboard de Vendas
![Dashboard de Vendas](https://github.com/Halina23/Portfolio-Halina-Oliveira/blob/main/Dashboard%20Ecommerce%20BI.png?raw=true)

![Análise de Vendas Loja Física](Análise%20de%20Vendas%20Loja%20Física.png)

### 🔍 Conclusões
### ❌ Cartão de Crédito é o maior gargalo de pagamento
Com 24 falhas registradas para apenas 6 vendas concluídas, o Cartão de Crédito apresenta a maior taxa de falha entre os métodos disponíveis — um ponto de atenção direto para a operação da loja.
### ⚠️ Taxa de cancelamento de 16,7%
Quase 1 em cada 6 vendas não é finalizada, o que representa perda direta de receita e indica possíveis problemas no processo de pagamento ou na experiência do cliente.
### 📍 São Paulo representa uma oportunidade de crescimento
SP registrou apenas 3 vendas no período — o menor volume entre todos os estados. Isso indica potencial inexplorado que pode ser ativado com ações promocionais direcionadas.
### 📦 Monitores e Notebooks dominam o faturamento
As duas categorias juntas respondem por praticamente todo o faturamento da loja, o que pode indicar falta de diversificação no mix de produtos oferecidos presencialmente.
### 💡 Query — Oportunidade de Promoção em SP
Para identificar clientes de São Paulo que nunca compraram na Loja Física, criei essa query como base para uma possível campanha de promoção direcionada:

-- Clientes de SP que nunca compraram na Loja Física

SELECT c.nome, c.email, c.cidade
FROM clientes c
JOIN estados e ON e.estado_id = c.estado_id
WHERE e.sigla = 'SP'
  AND c.cliente_id NOT IN (
    SELECT v.cliente_id
    FROM vendas v
    JOIN canais_venda cv ON cv.canal_id = v.canal_id
    WHERE cv.nome = 'Loja Fisica'
  );

### Essa consulta retorna uma lista de clientes potenciais que já estão na base, mas ainda não foram convertidos para o canal físico. 🎯


### 📚 Formação

🎓 Banco de Dados – Unicesumar (em andamento)

### 📬 Contato

### Email: halina.oliveira2021@gmail.com

### LinkedIn: www.linkedin.com/in/halina-oliveira

### GitHub: https://github.com/Halina23

### 📄 Portfólio completo:📄 [Clique aqui para ver o portfólio completo](https://drive.google.com/file/d/167OkjjViD9zCXDExa_uZg1iF1GW7B8lW/view?usp=sharing)
