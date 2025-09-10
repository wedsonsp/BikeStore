# Bike Stores Inc - Análise de Dados SQL

## Descrição do Projeto

Este projeto contém consultas SQL para análise de dados da empresa Bike Stores Inc, focando em métricas relevantes para as equipes de Marketing e Comercial. O banco de dados simula uma loja de bicicletas com múltiplas filiais, produtos, clientes e funcionários.

## Estrutura do Banco de Dados

O banco de dados é composto por 9 tabelas principais:

### Tabelas de Vendas (Sales)
- **customers**: Informações dos clientes
- **staffs**: Dados dos funcionários
- **stores**: Informações das lojas
- **orders**: Pedidos realizados
- **order_items**: Itens dos pedidos

### Tabelas de Produção (Production)
- **brands**: Marcas dos produtos
- **categories**: Categorias dos produtos
- **products**: Informações dos produtos
- **stocks**: Estoque por loja

## Arquivos do Projeto

1. **01_create_tables.sql**: Script para criação das tabelas e inserção de dados de exemplo
2. **02_queries.sql**: Consultas SQL solicitadas e análises adicionais

## Consultas Implementadas

### 1. Clientes que não realizaram compras
```sql
SELECT c.customer_id, c.first_name, c.last_name, c.email, c.phone, c.city, c.state
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.customer_id IS NULL
ORDER BY c.last_name, c.first_name;
```

**Objetivo**: Identificar clientes cadastrados que nunca fizeram uma compra.
**Técnica**: LEFT JOIN com filtro WHERE IS NULL para encontrar registros sem correspondência.

### 2. Produtos que não foram comprados
```sql
SELECT p.product_id, p.product_name, b.brand_name, cat.category_name, p.model_year, p.list_price
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
LEFT JOIN brands b ON p.brand_id = b.brand_id
LEFT JOIN categories cat ON p.category_id = cat.category_id
WHERE oi.product_id IS NULL
ORDER BY p.product_name;
```

**Objetivo**: Listar produtos que nunca foram vendidos.
**Técnica**: LEFT JOIN entre produtos e itens de pedido, filtrando registros sem vendas.

### 3. Produtos sem estoque
```sql
SELECT p.product_id, p.product_name, b.brand_name, cat.category_name, p.model_year, p.list_price
FROM products p
LEFT JOIN stocks s ON p.product_id = s.product_id
LEFT JOIN brands b ON p.brand_id = b.brand_id
LEFT JOIN categories cat ON p.category_id = cat.category_id
WHERE s.product_id IS NULL
ORDER BY p.product_name;
```

**Objetivo**: Identificar produtos que não possuem estoque em nenhuma loja.
**Técnica**: LEFT JOIN entre produtos e estoque, com filtro para produtos sem registro de estoque.

### 4. Vendas por marca e loja
```sql
SELECT b.brand_name, s.store_name, s.city, s.state,
       COUNT(oi.order_id) as total_orders,
       SUM(oi.quantity) as total_quantity_sold,
       SUM(oi.quantity * oi.list_price * (1 - oi.discount)) as total_revenue
FROM brands b
INNER JOIN products p ON b.brand_id = p.brand_id
INNER JOIN order_items oi ON p.product_id = oi.product_id
INNER JOIN orders o ON oi.order_id = o.order_id
INNER JOIN stores s ON o.store_id = s.store_id
GROUP BY b.brand_name, s.store_id, s.store_name, s.city, s.state
ORDER BY b.brand_name, s.store_name;
```

**Objetivo**: Agrupar vendas por marca e loja para análise de performance.
**Técnica**: INNER JOINs para conectar todas as tabelas e GROUP BY para agregação.

### 5. Funcionários sem pedidos
```sql
SELECT st.staff_id, st.first_name, st.last_name, st.email, st.phone, st.active,
       s.store_name, s.city, s.state,
       CASE 
           WHEN st.manager_id IS NOT NULL THEN 
               CONCAT(m.first_name, ' ', m.last_name)
           ELSE 'Sem gerente'
       END as manager_name
FROM staffs st
LEFT JOIN orders o ON st.staff_id = o.staff_id
LEFT JOIN stores s ON st.store_id = s.store_id
LEFT JOIN staffs m ON st.manager_id = m.staff_id
WHERE o.staff_id IS NULL
ORDER BY s.store_name, st.last_name, st.first_name;
```

**Objetivo**: Identificar funcionários que nunca processaram um pedido.
**Técnica**: LEFT JOIN entre funcionários e pedidos, com filtro para funcionários sem pedidos.

## Conceitos SQL Utilizados

### JOINs
- **LEFT JOIN**: Para encontrar registros sem correspondência
- **INNER JOIN**: Para conectar tabelas com dados relacionados
- **Self-referencing JOIN**: Para relacionar funcionários com seus gerentes

### Agregações
- **COUNT()**: Contar registros
- **SUM()**: Somar valores
- **AVG()**: Calcular médias
- **GROUP BY**: Agrupar resultados

### Filtros
- **WHERE IS NULL**: Encontrar registros sem correspondência
- **HAVING**: Filtrar grupos após agregação

## Consultas Adicionais

O arquivo `02_queries.sql` também inclui consultas adicionais úteis para análise:

- Resumo geral de vendas por loja
- Top 5 produtos mais vendidos
- Análise de clientes por região

## Como Executar

1. Execute o script `01_create_tables.sql` para criar o banco de dados e inserir dados de exemplo
2. Execute as consultas do arquivo `02_queries.sql` conforme necessário
3. Ajuste os filtros e parâmetros conforme suas necessidades específicas

## Considerações Técnicas

- Todas as consultas foram desenvolvidas para SQL Server (T-SQL)
- Os dados de exemplo incluem cenários para testar todas as consultas
- As consultas são otimizadas para performance com índices apropriados
- Inclui tratamento de valores NULL e casos extremos

## Resultados Esperados

As consultas fornecem insights valiosos para:
- **Marketing**: Identificar clientes inativos e produtos não vendidos
- **Comercial**: Analisar performance por marca e loja
- **Gestão**: Monitorar funcionários e estoque
- **Estratégia**: Tomar decisões baseadas em dados reais
