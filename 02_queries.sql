-- =============================================
-- Consultas SQL - Bike Stores Inc
-- =============================================

-- =============================================
-- 1. Listar todos Clientes que não tenham realizado uma compra
-- =============================================
-- Utiliza LEFT JOIN para encontrar clientes sem pedidos
-- e WHERE IS NULL para filtrar apenas os que não têm pedidos

SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    c.phone,
    c.city,
    c.state
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.customer_id IS NULL
ORDER BY c.last_name, c.first_name;

-- =============================================
-- 2. Listar os Produtos que não tenham sido comprados
-- =============================================
-- Utiliza LEFT JOIN para encontrar produtos sem itens de pedido
-- e WHERE IS NULL para filtrar apenas os que não foram comprados

SELECT 
    p.product_id,
    p.product_name,
    b.brand_name,
    cat.category_name,
    p.model_year,
    p.list_price
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
LEFT JOIN brands b ON p.brand_id = b.brand_id
LEFT JOIN categories cat ON p.category_id = cat.category_id
WHERE oi.product_id IS NULL
ORDER BY p.product_name;

-- =============================================
-- 3. Listar os Produtos sem Estoque
-- =============================================
-- Utiliza LEFT JOIN para encontrar produtos sem estoque
-- e WHERE IS NULL para filtrar apenas os que não têm estoque

SELECT 
    p.product_id,
    p.product_name,
    b.brand_name,
    cat.category_name,
    p.model_year,
    p.list_price
FROM products p
LEFT JOIN stocks s ON p.product_id = s.product_id
LEFT JOIN brands b ON p.brand_id = b.brand_id
LEFT JOIN categories cat ON p.category_id = cat.category_id
WHERE s.product_id IS NULL
ORDER BY p.product_name;

-- Alternativa: Produtos com estoque zero em todas as lojas
SELECT 
    p.product_id,
    p.product_name,
    b.brand_name,
    cat.category_name,
    p.model_year,
    p.list_price,
    COALESCE(SUM(s.quantity), 0) as total_stock
FROM products p
LEFT JOIN stocks s ON p.product_id = s.product_id
LEFT JOIN brands b ON p.brand_id = b.brand_id
LEFT JOIN categories cat ON p.category_id = cat.category_id
GROUP BY p.product_id, p.product_name, b.brand_name, cat.category_name, p.model_year, p.list_price
HAVING COALESCE(SUM(s.quantity), 0) = 0
ORDER BY p.product_name;

-- =============================================
-- 4. Agrupar a quantidade de vendas que uma determinada Marca por Loja
-- =============================================
-- Utiliza INNER JOIN para conectar todas as tabelas necessárias
-- e GROUP BY para agrupar por marca e loja

SELECT 
    b.brand_name,
    s.store_name,
    s.city,
    s.state,
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

-- Versão alternativa com mais detalhes por produto
SELECT 
    b.brand_name,
    s.store_name,
    p.product_name,
    COUNT(oi.order_id) as total_orders,
    SUM(oi.quantity) as total_quantity_sold,
    AVG(oi.list_price) as avg_price,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) as total_revenue
FROM brands b
INNER JOIN products p ON b.brand_id = p.brand_id
INNER JOIN order_items oi ON p.product_id = oi.product_id
INNER JOIN orders o ON oi.order_id = o.order_id
INNER JOIN stores s ON o.store_id = s.store_id
GROUP BY b.brand_name, s.store_id, s.store_name, p.product_id, p.product_name
ORDER BY b.brand_name, s.store_name, total_quantity_sold DESC;

-- =============================================
-- 5. Listar os Funcionários que não estejam relacionados a um Pedido
-- =============================================
-- Utiliza LEFT JOIN para encontrar funcionários sem pedidos
-- e WHERE IS NULL para filtrar apenas os que não têm pedidos

SELECT 
    st.staff_id,
    st.first_name,
    st.last_name,
    st.email,
    st.phone,
    st.active,
    s.store_name,
    s.city,
    s.state,
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

-- =============================================
-- Consultas Adicionais Úteis para Análise
-- =============================================

-- Resumo geral de vendas por loja
SELECT 
    s.store_name,
    s.city,
    s.state,
    COUNT(DISTINCT o.order_id) as total_orders,
    COUNT(DISTINCT o.customer_id) as unique_customers,
    SUM(oi.quantity) as total_items_sold,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) as total_revenue
FROM stores s
INNER JOIN orders o ON s.store_id = o.store_id
INNER JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY s.store_id, s.store_name, s.city, s.state
ORDER BY total_revenue DESC;

-- Top 5 produtos mais vendidos
SELECT 
    p.product_name,
    b.brand_name,
    cat.category_name,
    SUM(oi.quantity) as total_quantity_sold,
    COUNT(DISTINCT oi.order_id) as total_orders,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) as total_revenue
FROM products p
INNER JOIN brands b ON p.brand_id = b.brand_id
INNER JOIN categories cat ON p.category_id = cat.category_id
INNER JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name, b.brand_name, cat.category_name
ORDER BY total_quantity_sold DESC
OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY;

-- Análise de clientes por região
SELECT 
    c.state,
    c.city,
    COUNT(DISTINCT c.customer_id) as total_customers,
    COUNT(DISTINCT o.order_id) as total_orders,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) as total_revenue
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
LEFT JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.state, c.city
ORDER BY total_revenue DESC;
