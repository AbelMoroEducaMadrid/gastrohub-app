-- Script SQL muy extenso de datos de prueba para Gastro & Hub (un solo restaurante)

-- 1. Unidades de medida (mt_units)
INSERT INTO mt_units (name, symbol) VALUES
('Kilogramo', 'kg'),
('Litro', 'L'),
('Unidad', 'u'),
('Gramo', 'g'),
('Mililitro', 'ml'),
('Metro', 'm'),
('Centímetro', 'cm'),
('Docena', 'doc');

-- 2. Roles (mt_roles)
INSERT INTO mt_roles (name, description, created_at) VALUES
('ROLE_ADMIN', 'Administrador de GastroHUB', CURRENT_TIMESTAMP),
('ROLE_SYSTEM', 'Sistema de GastroHUB', CURRENT_TIMESTAMP),
('ROLE_USER', 'Usuario de GastroHUB', CURRENT_TIMESTAMP),
('ROLE_OWNER', 'Dueño del restaurante', CURRENT_TIMESTAMP),
('ROLE_MANAGER', 'Encargado del restaurante', CURRENT_TIMESTAMP),
('ROLE_WAITER', 'Camarero del restaurante', CURRENT_TIMESTAMP),
('ROLE_COOK', 'Cocinero del restaurante', CURRENT_TIMESTAMP),
('ROLE_CASHIER', 'Cajero del restaurante', CURRENT_TIMESTAMP),
('ROLE_DELIVERY', 'Repartidor del restaurante', CURRENT_TIMESTAMP);

-- 3. Tipos de atributos (mt_attribute_types)
INSERT INTO mt_attribute_types (name, created_at) VALUES
('Alérgeno', CURRENT_TIMESTAMP),
('Dietético', CURRENT_TIMESTAMP),
('Sabor', CURRENT_TIMESTAMP),
('Textura', CURRENT_TIMESTAMP),
('Origen', CURRENT_TIMESTAMP);

-- 4. Atributos (mt_attributes)
INSERT INTO mt_attributes (type_id, name, description, created_at) VALUES
(1, 'Contiene gluten', 'Puede contener gluten', CURRENT_TIMESTAMP),
(1, 'Contiene nueces', 'Puede contener nueces', CURRENT_TIMESTAMP),
(1, 'Contiene lácteos', 'Puede contener lácteos', CURRENT_TIMESTAMP),
(1, 'Contiene mariscos', 'Puede contener mariscos', CURRENT_TIMESTAMP),
(2, 'Vegano', 'Apto para veganos', CURRENT_TIMESTAMP),
(2, 'Sin lactosa', 'No contiene lactosa', CURRENT_TIMESTAMP),
(2, 'Sin gluten', 'Apto para celíacos', CURRENT_TIMESTAMP),
(2, 'Bajo en calorías', 'Bajo contenido calórico', CURRENT_TIMESTAMP),
(3, 'Picante', 'Sabor picante', CURRENT_TIMESTAMP),
(3, 'Dulce', 'Sabor dulce', CURRENT_TIMESTAMP),
(3, 'Salado', 'Sabor salado', CURRENT_TIMESTAMP),
(4, 'Crujiente', 'Textura crujiente', CURRENT_TIMESTAMP),
(4, 'Suave', 'Textura suave', CURRENT_TIMESTAMP),
(5, 'Local', 'Producto de origen local', CURRENT_TIMESTAMP),
(5, 'Importado', 'Producto importado', CURRENT_TIMESTAMP);

-- 5. Usuarios (users)
-- Nota: password_hash es un placeholder. En producción, usa un hash real (ej. bcrypt).
INSERT INTO users (name, email, password_hash, phone, created_by, created_at) VALUES
('Ana Gómez', 'ana@example.com', 'hashed_password_2', '987654321', 1, CURRENT_TIMESTAMP), -- Dueño Restaurante 1
('Carlos López', 'carlos@example.com', 'hashed_password_3', '555555555', 1, CURRENT_TIMESTAMP), -- Camarero Restaurante 1
('María Rodríguez', 'maria@example.com', 'hashed_password_4', '666666666', 1, CURRENT_TIMESTAMP), -- Cocinero Restaurante 1
('Luis Fernández', 'luis@example.com', 'hashed_password_5', '777777777', 1, CURRENT_TIMESTAMP), -- Cajero Restaurante 1
('Beatriz Morales', 'beatriz@example.com', 'hashed_password_14', '777777777', 1, CURRENT_TIMESTAMP), -- Encargado Restaurante 1
('Tomás Herrera', 'tomas@example.com', 'hashed_password_15', '888888888', 1, CURRENT_TIMESTAMP); -- Repartidor Restaurante 1

-- 6. Relación usuarios-roles (rel_user_roles)
INSERT INTO rel_user_roles (user_id, role_id, created_at) VALUES
(1, 4, CURRENT_TIMESTAMP), -- ROLE_OWNER para Ana
(2, 6, CURRENT_TIMESTAMP), -- ROLE_WAITER para Carlos
(3, 7, CURRENT_TIMESTAMP), -- ROLE_COOK para María
(4, 8, CURRENT_TIMESTAMP), -- ROLE_CASHIER para Luis
(5, 5, CURRENT_TIMESTAMP), -- ROLE_MANAGER para Beatriz
(6, 9, CURRENT_TIMESTAMP); -- ROLE_DELIVERY para Tomás

-- 7. Restaurantes (restaurants)
INSERT INTO restaurants (name, owner_id, address, cuisine_type, created_by, created_at) VALUES
('Restaurante Italiano', 1, 'Calle Italia 123', 'Italiana', 1, CURRENT_TIMESTAMP);

-- UPDATE
UPDATE users SET restaurant_id = 1;

-- 8. Diseños (layouts)
INSERT INTO layouts (restaurant_id, name, description, created_by, created_at) VALUES
(1, 'Sala Principal', 'Diseño de la sala principal del restaurante italiano', 1, CURRENT_TIMESTAMP),
(1, 'Terraza', 'Diseño de la terraza del restaurante italiano', 1, CURRENT_TIMESTAMP),
(1, 'Privado', 'Sala privada para eventos', 1, CURRENT_TIMESTAMP);

-- 9. Mesas (tables)
INSERT INTO tables (layout_id, number, state, capacity, created_by, created_at) VALUES
(1, 1, 'available', 4, 1, CURRENT_TIMESTAMP),
(1, 2, 'available', 2, 1, CURRENT_TIMESTAMP),
(1, 3, 'available', 6, 1, CURRENT_TIMESTAMP),
(1, 4, 'available', 4, 1, CURRENT_TIMESTAMP),
(2, 1, 'available', 4, 1, CURRENT_TIMESTAMP),
(2, 2, 'occupied', 2, 1, CURRENT_TIMESTAMP),
(2, 3, 'available', 6, 1, CURRENT_TIMESTAMP),
(3, 1, 'available', 8, 1, CURRENT_TIMESTAMP),
(3, 2, 'available', 10, 1, CURRENT_TIMESTAMP);

-- 10. Categorías de menú (menu_categories)
INSERT INTO menu_categories (restaurant_id, name, description, available, created_by, created_at) VALUES
(1, 'Entrantes', 'Platos para empezar', TRUE, 1, CURRENT_TIMESTAMP),
(1, 'Platos Principales', 'Platos fuertes', TRUE, 1, CURRENT_TIMESTAMP),
(1, 'Postres', 'Dulces y postres', TRUE, 1, CURRENT_TIMESTAMP),
(1, 'Bebidas', 'Bebidas refrescantes', TRUE, 1, CURRENT_TIMESTAMP);

-- 11. Ítems de menú (menu_items)
INSERT INTO menu_items (category_id, name, price, created_by, created_at) VALUES
(1, 'Ensalada César', 8.50, 1, CURRENT_TIMESTAMP),
(1, 'Bruschetta', 6.00, 1, CURRENT_TIMESTAMP),
(1, 'Carpaccio', 9.00, 1, CURRENT_TIMESTAMP),
(2, 'Pizza Margarita', 12.00, 1, CURRENT_TIMESTAMP),
(2, 'Pasta Carbonara', 14.00, 1, CURRENT_TIMESTAMP),
(2, 'Lasagna', 13.50, 1, CURRENT_TIMESTAMP),
(3, 'Tiramisú', 5.00, 1, CURRENT_TIMESTAMP),
(3, 'Helado', 3.50, 1, CURRENT_TIMESTAMP),
(3, 'Panna Cotta', 4.50, 1, CURRENT_TIMESTAMP),
(4, 'Agua', 2.00, 1, CURRENT_TIMESTAMP),
(4, 'Vino Tinto', 6.00, 1, CURRENT_TIMESTAMP);

-- 12. Ingredientes (ingredients)
INSERT INTO ingredients (restaurant_id, name, unit_id, quantity, capacity, cost_per_unit, min_level, created_by, created_at) VALUES
(1, 'Harina', 1, 20.0, 50.0, 1.20, 5.0, 1, CURRENT_TIMESTAMP),
(1, 'Tomate', 3, 50, 100, 0.50, 10, 1, CURRENT_TIMESTAMP),
(1, 'Queso Mozzarella', 1, 10.0, 20.0, 3.00, 2.0, 1, CURRENT_TIMESTAMP),
(1, 'Aceite de Oliva', 2, 5.0, 10.0, 4.00, 1.0, 1, CURRENT_TIMESTAMP),
(1, 'Albahaca', 4, 200, 500, 0.02, 50, 1, CURRENT_TIMESTAMP),
(1, 'Ajo', 4, 100, 200, 0.05, 20, 1, CURRENT_TIMESTAMP),
(1, 'Cebolla', 3, 30, 50, 0.40, 5, 1, CURRENT_TIMESTAMP),
(1, 'Pasta', 1, 15.0, 20.0, 2.00, 3.0, 1, CURRENT_TIMESTAMP),
(1, 'Carne Molida', 1, 8.0, 15.0, 5.00, 2.0, 1, CURRENT_TIMESTAMP),
(1, 'Leche', 2, 10.0, 20.0, 1.00, 2.0, 1, CURRENT_TIMESTAMP);

-- 13. Productos preparados (prepared_products)
INSERT INTO prepared_products (restaurant_id, name, unit_id, quantity, capacity, cost, min_level, preparation_time, created_by, created_at) VALUES
(1, 'Salsa de Tomate', 2, 10.0, 20.0, 2.50, 2.0, 30, 1, CURRENT_TIMESTAMP),
(1, 'Masa de Pizza', 1, 5.0, 10.0, 1.00, 1.0, 15, 1, CURRENT_TIMESTAMP),
(1, 'Crema de Queso', 2, 3.0, 5.0, 3.00, 1.0, 10, 1, CURRENT_TIMESTAMP),
(1, 'Pesto', 2, 2.0, 5.0, 4.00, 1.0, 10, 1, CURRENT_TIMESTAMP),
(1, 'Masa para Pasta', 1, 4.0, 8.0, 1.50, 1.0, 20, 1, CURRENT_TIMESTAMP);

-- 14. Órdenes (orders)
INSERT INTO orders (restaurant_id, table_id, state, notes, urgent, created_by, created_at) VALUES
(1, 1, 'pending', 'Sin cebolla', FALSE, 2, CURRENT_TIMESTAMP),
(1, 2, 'completed', 'Extra queso', FALSE, 2, CURRENT_TIMESTAMP),
(1, NULL, 'pending', 'Comanda de barra', FALSE, 2, CURRENT_TIMESTAMP),
(1, 4, 'pending', 'Rápido', TRUE, 2, CURRENT_TIMESTAMP),
(1, 5, 'pending', 'Sin sal', FALSE, 2, CURRENT_TIMESTAMP),
(1, 6, 'completed', 'Con extra salsa', FALSE, 2, CURRENT_TIMESTAMP),
(1, 7, 'pending', 'Para llevar', FALSE, 2, CURRENT_TIMESTAMP),
(1, 8, 'completed', 'Sin gluten', FALSE, 2, CURRENT_TIMESTAMP),
(1, 9, 'pending', 'Extra picante', TRUE, 2, CURRENT_TIMESTAMP);

-- 15. Ítems de orden (order_items)
INSERT INTO order_items (order_id, menu_item_id, quantity, notes, state, price_at_order, created_by, created_at) VALUES
(1, 1, 2, 'Sin aderezo', 'pending', 8.50, 2, CURRENT_TIMESTAMP),
(1, 3, 1, NULL, 'pending', 12.00, 2, CURRENT_TIMESTAMP),
(2, 2, 3, 'Con extra queso', 'completed', 6.00, 2, CURRENT_TIMESTAMP),
(2, 5, 1, NULL, 'completed', 14.00, 2, CURRENT_TIMESTAMP),
(3, 4, 2, 'Sin tomate', 'pending', 12.00, 2, CURRENT_TIMESTAMP),
(4, 6, 1, 'Extra salsa', 'pending', 13.50, 2, CURRENT_TIMESTAMP),
(5, 7, 2, 'Sin sal', 'pending', 5.00, 2, CURRENT_TIMESTAMP),
(6, 8, 1, 'Extra helado', 'completed', 3.50, 2, CURRENT_TIMESTAMP),
(7, 9, 3, 'Para llevar', 'pending', 4.50, 2, CURRENT_TIMESTAMP),
(8, 10, 2, 'Sin gluten', 'completed', 2.00, 2, CURRENT_TIMESTAMP),
(9, 11, 1, 'Extra picante', 'pending', 6.00, 2, CURRENT_TIMESTAMP);

-- 16. Métodos de pago (mt_payment_methods)
INSERT INTO mt_payment_methods (name, description) VALUES
('Tarjeta', 'Pago con tarjeta de crédito/débito'),
('Efectivo', 'Pago en efectivo'),
('Transferencia', 'Transferencia bancaria'),
('PayPal', 'Pago mediante PayPal'),
('Bizum', 'Pago mediante Bizum');

-- 17. Pagos (payments)
INSERT INTO payments (order_id, method_id, amount, state, payment_timestamp, created_by, created_at) VALUES
(1, 1, 29.00, 'pending', NULL, 2, CURRENT_TIMESTAMP),
(2, 2, 32.00, 'completed', CURRENT_TIMESTAMP, 2, CURRENT_TIMESTAMP),
(3, 3, 24.00, 'pending', NULL, 2, CURRENT_TIMESTAMP),
(4, 1, 13.50, 'pending', NULL, 2, CURRENT_TIMESTAMP),
(5, 2, 10.00, 'pending', NULL, 2, CURRENT_TIMESTAMP),
(6, 4, 3.50, 'completed', CURRENT_TIMESTAMP, 2, CURRENT_TIMESTAMP),
(7, 5, 13.50, 'pending', NULL, 2, CURRENT_TIMESTAMP),
(8, 1, 4.00, 'completed', CURRENT_TIMESTAMP, 2, CURRENT_TIMESTAMP),
(9, 3, 6.00, 'pending', NULL, 2, CURRENT_TIMESTAMP);

-- 18. Retroalimentación (feedback)
INSERT INTO feedback (order_id, rating, comment, created_by, created_at) VALUES
(1, 5, 'Excelente servicio y comida', 2, CURRENT_TIMESTAMP),
(2, 4, 'Buena atención, pero un poco lento', 2, CURRENT_TIMESTAMP),
(3, 3, 'Comida buena, pero fría', 2, CURRENT_TIMESTAMP),
(4, 5, 'Rápido y sabroso', 2, CURRENT_TIMESTAMP),
(5, 4, 'Buen sabor, pero caro', 2, CURRENT_TIMESTAMP),
(6, 5, 'El helado estaba delicioso', 2, CURRENT_TIMESTAMP),
(7, 3, 'Comida para llevar fría', 2, CURRENT_TIMESTAMP),
(8, 4, 'Buena opción sin gluten', 2, CURRENT_TIMESTAMP),
(9, 5, 'Picante perfecto', 2, CURRENT_TIMESTAMP);