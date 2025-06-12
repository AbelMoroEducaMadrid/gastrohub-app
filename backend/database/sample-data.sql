-- Inserciones para tablas maestras
-- Unidades de medida
INSERT INTO mt_units (name, symbol)
VALUES ('Kilogramo', 'kg'),
       ('Litro', 'L'),
       ('Unidad', 'u'),
       ('Gramo', 'g'),
       ('Mililitro', 'ml'),
       ('Metro', 'm'),
       ('Centímetro', 'cm'),
       ('Docena', 'doc');

-- Roles
INSERT INTO mt_roles (name)
VALUES ('ROLE_ADMIN'),
       ('ROLE_SYSTEM'),
       ('ROLE_USER'),
       ('ROLE_OWNER'),
       ('ROLE_MANAGER'),
       ('ROLE_WAITER'),
       ('ROLE_COOK'),
       ('ROLE_CASHIER'),
       ('ROLE_DELIVERY');

-- Atributos
INSERT INTO mt_attributes (name, description)
VALUES ('Gluten', 'Contiene cereales como trigo, centeno, cebada o avena'),
       ('Crustáceos', 'Contiene crustáceos como cangrejo, langosta, gambas, etc.'),
       ('Huevo', 'Contiene huevos o productos derivados del huevo'),
       ('Pescado', 'Contiene pescado o productos derivados del pescado'),
       ('Cacahuetes', 'Contiene cacahuetes o productos a base de cacahuetes'),
       ('Soja', 'Contiene soja o productos a base de soja'),
       ('Lactosa', 'Contiene leche o productos lácteos'),
       ('Frutos secos', 'Contiene almendras, avellanas, nueces, anacardos, etc.'),
       ('Apio', 'Contiene apio o productos derivados del apio'),
       ('Mostaza', 'Contiene mostaza o productos derivados de la mostaza'),
       ('Sésamo', 'Contiene granos de sésamo o productos a base de sésamo'),
       ('Sulfitos', 'Contiene dióxido de azufre y sulfitos en concentraciones superiores a 10 mg/kg o 10 mg/l'),
       ('Altramuces', 'Contiene altramuces o productos a base de altramuces'),
       ('Moluscos', 'Contiene moluscos como mejillones, ostras, calamares, etc.'),
       ('Sin gluten', 'Producto apto para celíacos'),
       ('Sin lactosa', 'Producto apto para intolerantes a la lactosa'),
       ('Picante', 'Contiene ingredientes picantes'),
       ('Vegetariano', 'Apto para vegetarianos, sin carne ni pescado'),
       ('Vegano', 'Apto para veganos, sin productos de origen animal'),
       ('Bajo en calorías', 'Producto con bajo contenido calórico'),
       ('Orgánico', 'Elaborado con ingredientes orgánicos certificados'),
       ('Local', 'Elaborado con ingredientes de origen local');

-- Planes de pago
INSERT INTO payment_plans (name, description, monthly_price, max_users, yearly_discount, features)
VALUES ('Básico', 'Gestión esencial de pedidos y mesas.', 9.99, 5, 5,
        ARRAY ['Pedidos y mesas en tiempo real', 'Soporte para hasta 5 usuarios', 'Acceso desde dispositivos móviles']),
       ('Avanzado', 'Control avanzado e inventario.', 24.99, 15, 10,
        ARRAY ['Gestión de inventario con alertas', 'Gestión de reservas', 'Notificaciones en tiempo real', 'Soporte para hasta 15 usuarios']),
       ('Pro', 'Optimización y análisis predictivo.', 39.99, 25, 15,
        ARRAY ['Análisis predictivo de inventario', 'Reportes detallados con predicciones', 'Integración con sistemas externos', 'Soporte para hasta 25 usuarios']),
       ('Premium', 'Todas las funciones + soporte VIP.', 69.99, 35, 20,
        ARRAY ['Soporte prioritario 24/7', 'Escalabilidad para múltiples locales', 'Gestión de promociones y sugerencias', 'Soporte para hasta 35 usuarios']),
       ('Personalizado', 'Soluciones a medida para tu negocio.', 0.00, NULL, 0,
        ARRAY ['Funcionalidades personalizadas', 'Soporte dedicado']);

-- Restaurantes
INSERT INTO restaurants (name, address, cuisine_type, description, payment_plan_id, paid)
VALUES ('La Trattoria', 'Calle Falsa 123, Ciudad', 'Italiana',
        'Restaurante italiano con ambiente familiar y auténtica cocina italiana', 4, true);

-- Usuarios
INSERT INTO users (name, email, password_hash, role_id, phone, restaurant_id, verified)
VALUES ('Admin', 'admin@trattoria.com', '$2a$12$abc123xyz789...', 1, '123456789', NULL, true),
       ('Propietario', 'owner@trattoria.com', '$2a$12$def456xyz789...', 4, '987654321', 1, true),
       ('Gerente', 'manager@trattoria.com', '$2a$12$ghi789xyz789...', 5, '555555555', 1, true),
       ('Mesero1', 'waiter1@trattoria.com', '$2a$12$jkl012xyz789...', 6, '666666666', 1, true),
       ('Mesero2', 'waiter2@trattoria.com', '$2a$12$mno345xyz789...', 6, '777777777', 1, true),
       ('Cocinero1', 'cook1@trattoria.com', '$2a$12$pqr678xyz789...', 7, '888888888', 1, true),
       ('Cocinero2', 'cook2@trattoria.com', '$2a$12$stu901xyz789...', 7, '999999999', 1, true),
       ('Cajero', 'cashier@trattoria.com', '$2a$12$vwx234xyz789...', 8, '111111111', 1, true),
       ('Delivery', 'delivery@trattoria.com', '$2a$12$yza567xyz789...', 9, '222222222', 1, true);

-- Diseños
INSERT INTO layouts (restaurant_id, name)
VALUES (1, 'Comedor Principal'),
       (1, 'Terraza'),
       (1, 'Sala Privada');

-- Mesas
INSERT INTO tables (layout_id, number, state, capacity)
VALUES (1, 1, 'disponible', 4),
       (1, 2, 'ocupada', 6),
       (1, 3, 'reservada', 8),
       (1, 4, 'disponible', 2),
       (2, 1, 'disponible', 4),
       (2, 2, 'ocupada', 4),
       (2, 3, 'reservada', 6),
       (2, 4, 'disponible', 4),
       (3, 1, 'disponible', 10),
       (3, 2, 'reservada', 12),
       (3, 3, 'ocupada', 8),
       (3, 4, 'disponible', 6);

-- Comandas
INSERT INTO orders (restaurant_id, table_id, state, notes, urgent, payment_state, payment_method)
VALUES (1, 1, 'pendiente', 'Sin cebolla', FALSE, 'pendiente', 'efectivo'),
       (1, 6, 'en progreso', 'Extra queso', TRUE, 'pendiente', 'tarjeta'),
       (1, 4, 'servida', 'Para llevar', FALSE, 'completado', 'móvil'),
       (1, 8, 'cancelada', 'Cliente se fue', FALSE, 'cancelado', 'vale'),
       (1, NULL, 'pendiente', 'Pedido en barra', FALSE, 'pendiente', 'efectivo'),
       (1, 2, 'servida', 'Evento privado', FALSE, 'completado', 'efectivo');

-- Categorías (genéricas para cualquier restaurante)
INSERT INTO mt_categories (name)
VALUES ('Entrantes'),
       ('Platos Principales'),
       ('Acompañamientos'),
       ('Postres'),
       ('Bebidas'),
       ('Menús Especiales');

-- Ingredientes
INSERT INTO ingredients (restaurant_id, name, unit_id, stock, cost_per_unit, min_stock, is_composite)
VALUES (1, 'Harina', 1, 50.0, 2.50, 10.0, FALSE),
       (1, 'Tomate', 1, 30.0, 1.80, 5.0, FALSE),
       (1, 'Mozzarella', 1, 20.0, 3.50, 5.0, FALSE),
       (1, 'Aceite de oliva', 2, 10.0, 5.00, 2.0, FALSE),
       (1, 'Albahaca', 4, 100.0, 0.10, 20.0, FALSE),
       (1, 'Salsa de tomate', 2, 15.0, 2.00, 3.0, TRUE),
       (1, 'Masa para pizza', 3, 20.0, 1.50, 5.0, TRUE),
       (1, 'Agua Mineral', 3, 100.0, 0.50, 20.0, FALSE),
       (1, 'Vino Tinto', 3, 50.0, 10.00, 10.0, FALSE);

-- Relación Ingredientes Compuestos
INSERT INTO rel_ingredient_ingredients (parent_ingredient_id, component_ingredient_id, quantity, unit_id)
VALUES (6, 2, 0.5, 1),
       (6, 4, 0.1, 2),
       (7, 1, 1.0, 1),
       (7, 4, 0.2, 2);

-- Relación Ingredientes-Atributos
INSERT INTO rel_ingredients_attributes (ingredient_id, attribute_id)
VALUES (1, 1),  -- Harina: Gluten
       (3, 7),  -- Mozzarella: Lactosa
       (5, 18), -- Albahaca: Vegano
       (6, 18), -- Salsa de tomate: Vegano
       (7, 1),  -- Masa para pizza: Gluten
       (8, 15), -- Agua Mineral: Sin gluten
       (9, 12);
-- Vino Tinto: Sulfitos

-- Productos
INSERT INTO products (name, restaurant_id, price, available, is_kitchen, category_id)
VALUES ('Bruschetta', 1, 3.00, TRUE, TRUE, 1),
       ('Pizza Margarita', 1, 7.00, TRUE, TRUE, 2),
       ('Pizza Pepperoni', 1, 8.00, TRUE, TRUE, 2),
       ('Spaghetti Carbonara', 1, 6.00, TRUE, TRUE, 2),
       ('Lasagna', 1, 9.00, TRUE, TRUE, 2),
       ('Tiramisú', 1, 4.00, TRUE, TRUE, 4),
       ('Gelato', 1, 3.00, TRUE, TRUE, 4),
       ('Agua Mineral', 1, 0.50, TRUE, FALSE, 5),
       ('Vino Tinto', 1, 10.00, TRUE, FALSE, 5);

-- Relación Productos-Ingredientes
INSERT INTO rel_products_ingredients (product_id, ingredient_id, quantity)
VALUES (1, 2, 0.2),  -- Bruschetta: Tomate
       (1, 4, 0.05), -- Bruschetta: Aceite de oliva
       (2, 7, 1.0),  -- Pizza Margarita: Masa para pizza
       (2, 6, 0.3),  -- Pizza Margarita: Salsa de tomate
       (2, 3, 0.2),  -- Pizza Margarita: Mozzarella
       (3, 7, 1.0),  -- Pizza Pepperoni: Masa para pizza
       (3, 6, 0.3),  -- Pizza Pepperoni: Salsa de tomate
       (4, 1, 0.3),  -- Spaghetti Carbonara: Harina
       (5, 1, 0.4),  -- Lasagna: Harina
       (6, 3, 0.1),  -- Tiramisú: Mozzarella
       (7, 3, 0.05), -- Gelato: Mozzarella
       (8, 8, 1.0),  -- Agua Mineral
       (9, 9, 1.0); -- Vino Tinto