-- =============================================
-- Script de Criação das Tabelas - Bike Stores Inc
-- =============================================

-- Criar banco de dados (opcional)
-- CREATE DATABASE BikeStores;
-- USE BikeStores;

-- Tabela de Marcas
CREATE TABLE brands (
    brand_id INT IDENTITY(1,1) PRIMARY KEY,
    brand_name VARCHAR(255) NOT NULL
);

-- Tabela de Categorias
CREATE TABLE categories (
    category_id INT IDENTITY(1,1) PRIMARY KEY,
    category_name VARCHAR(255) NOT NULL
);

-- Tabela de Lojas
CREATE TABLE stores (
    store_id INT IDENTITY(1,1) PRIMARY KEY,
    store_name VARCHAR(255) NOT NULL,
    phone VARCHAR(25),
    email VARCHAR(255),
    street VARCHAR(255),
    city VARCHAR(255),
    state VARCHAR(10),
    zip_code VARCHAR(5)
);

-- Tabela de Funcionários
CREATE TABLE staffs (
    staff_id INT IDENTITY(1,1) PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    phone VARCHAR(25),
    active TINYINT NOT NULL,
    store_id INT NOT NULL,
    manager_id INT,
    FOREIGN KEY (store_id) REFERENCES stores(store_id),
    FOREIGN KEY (manager_id) REFERENCES staffs(staff_id)
);

-- Tabela de Clientes
CREATE TABLE customers (
    customer_id INT IDENTITY(1,1) PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    phone VARCHAR(25),
    email VARCHAR(255),
    street VARCHAR(255),
    city VARCHAR(255),
    state VARCHAR(10),
    zip_code VARCHAR(5)
);

-- Tabela de Produtos
CREATE TABLE products (
    product_id INT IDENTITY(1,1) PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    brand_id INT NOT NULL,
    category_id INT NOT NULL,
    model_year INT,
    list_price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (brand_id) REFERENCES brands(brand_id),
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

-- Tabela de Pedidos
CREATE TABLE orders (
    order_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_id INT,
    order_status TINYINT NOT NULL,
    order_date DATE NOT NULL,
    required_date DATE,
    shipped_date DATE,
    store_id INT NOT NULL,
    staff_id INT NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (store_id) REFERENCES stores(store_id),
    FOREIGN KEY (staff_id) REFERENCES staffs(staff_id)
);

-- Tabela de Itens do Pedido
CREATE TABLE order_items (
    order_id INT NOT NULL,
    item_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    list_price DECIMAL(10,2) NOT NULL,
    discount DECIMAL(4,2) NOT NULL DEFAULT 0,
    PRIMARY KEY (order_id, item_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Tabela de Estoque
CREATE TABLE stocks (
    store_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT,
    PRIMARY KEY (store_id, product_id),
    FOREIGN KEY (store_id) REFERENCES stores(store_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- =============================================
-- Inserção de Dados de Exemplo (opcional)
-- =============================================

-- Inserir marcas
INSERT INTO brands (brand_name) VALUES 
('Trek'), ('Giant'), ('Specialized'), ('Cannondale'), ('Scott');

-- Inserir categorias
INSERT INTO categories (category_name) VALUES 
('Mountain Bikes'), ('Road Bikes'), ('Hybrid Bikes'), ('Electric Bikes'), ('Accessories');

-- Inserir lojas
INSERT INTO stores (store_name, phone, email, street, city, state, zip_code) VALUES 
('Downtown Store', '(555) 123-4567', 'downtown@bikestores.com', '123 Main St', 'New York', 'NY', '10001'),
('Uptown Store', '(555) 234-5678', 'uptown@bikestores.com', '456 Oak Ave', 'New York', 'NY', '10002'),
('Suburban Store', '(555) 345-6789', 'suburban@bikestores.com', '789 Pine St', 'Brooklyn', 'NY', '11201');

-- Inserir funcionários
INSERT INTO staffs (first_name, last_name, email, phone, active, store_id, manager_id) VALUES 
('John', 'Doe', 'john.doe@bikestores.com', '(555) 111-1111', 1, 1, NULL),
('Jane', 'Smith', 'jane.smith@bikestores.com', '(555) 222-2222', 1, 1, 1),
('Mike', 'Johnson', 'mike.johnson@bikestores.com', '(555) 333-3333', 1, 2, NULL),
('Sarah', 'Wilson', 'sarah.wilson@bikestores.com', '(555) 444-4444', 1, 2, 3);

-- Inserir clientes
INSERT INTO customers (first_name, last_name, phone, email, street, city, state, zip_code) VALUES 
('Alice', 'Brown', '(555) 555-0001', 'alice.brown@email.com', '100 First St', 'New York', 'NY', '10001'),
('Bob', 'Davis', '(555) 555-0002', 'bob.davis@email.com', '200 Second Ave', 'New York', 'NY', '10002'),
('Carol', 'Green', '(555) 555-0003', 'carol.green@email.com', '300 Third St', 'Brooklyn', 'NY', '11201'),
('David', 'White', '(555) 555-0004', 'david.white@email.com', '400 Fourth Ave', 'Queens', 'NY', '11301');

-- Inserir produtos
INSERT INTO products (product_name, brand_id, category_id, model_year, list_price) VALUES 
('Mountain Pro 1000', 1, 1, 2023, 1299.99),
('Road Speed 500', 2, 2, 2023, 899.99),
('Hybrid Comfort 300', 3, 3, 2023, 599.99),
('Electric City 200', 4, 4, 2023, 1999.99),
('Helmet Safety Pro', 5, 5, 2023, 79.99);

-- Inserir pedidos
INSERT INTO orders (customer_id, order_status, order_date, required_date, shipped_date, store_id, staff_id) VALUES 
(1, 4, '2023-01-15', '2023-01-20', '2023-01-18', 1, 1),
(2, 4, '2023-01-16', '2023-01-21', '2023-01-19', 1, 2),
(3, 4, '2023-01-17', '2023-01-22', '2023-01-20', 2, 3),
(1, 4, '2023-01-18', '2023-01-23', '2023-01-21', 2, 4);

-- Inserir itens do pedido
INSERT INTO order_items (order_id, item_id, product_id, quantity, list_price, discount) VALUES 
(1, 1, 1, 1, 1299.99, 0.00),
(1, 2, 5, 1, 79.99, 0.10),
(2, 1, 2, 1, 899.99, 0.05),
(3, 1, 3, 1, 599.99, 0.00),
(4, 1, 4, 1, 1999.99, 0.15);

-- Inserir estoque
INSERT INTO stocks (store_id, product_id, quantity) VALUES 
(1, 1, 5),
(1, 2, 3),
(1, 3, 8),
(1, 4, 2),
(1, 5, 15),
(2, 1, 4),
(2, 2, 6),
(2, 3, 2),
(2, 4, 1),
(2, 5, 12),
(3, 1, 0),  -- Produto sem estoque
(3, 2, 0),  -- Produto sem estoque
(3, 3, 0),  -- Produto sem estoque
(3, 4, 0),  -- Produto sem estoque
(3, 5, 0);  -- Produto sem estoque
