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
       ('Moluscos', 'Contiene moluscos como mejillones, ostras, calamares, etc.');

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
       ('Delivery', 'delivery@trattoria.com', '$2a$12$yza567xyz789...', 9, '222222222', 1, true),
       ('Mesero3', 'waiter3@trattoria.com', '$2a$12$abc123xyz789...', 6, '333333333', 1, true),
       ('Mesero4', 'waiter4@trattoria.com', '$2a$12$def456xyz789...', 6, '444444444', 1, true),
       ('Cocinero3', 'cook3@trattoria.com', '$2a$12$ghi789xyz789...', 7, '555555556', 1, true),
       ('Delivery2', 'delivery2@trattoria.com', '$2a$12$jkl012xyz789...', 9, '666666667', 1, true);

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
       (3, 4, 'disponible', 6),
       (1, 5, 'disponible', 4),
       (1, 6, 'ocupada', 2),
       (1, 7, 'reservada', 6),
       (1, 8, 'disponible', 4),
       (2, 5, 'disponible', 4),
       (2, 6, 'ocupada', 4),
       (2, 7, 'reservada', 2),
       (3, 5, 'disponible', 8),
       (3, 6, 'ocupada', 10);

-- Comandas
INSERT INTO orders (restaurant_id, table_id, state, notes, urgent, payment_state, payment_method)
VALUES (1, 1, 'pendiente', 'Sin cebolla', FALSE, 'pendiente', 'efectivo'),
       (1, 6, 'preparando', 'Extra queso', TRUE, 'pendiente', 'tarjeta'),
       (1, 4, 'servida', 'Para llevar', FALSE, 'completado', 'tarjeta'),
       (1, 8, 'cancelada', 'Cliente se fue', FALSE, 'cancelado', 'tarjeta'),
       (1, NULL, 'pendiente', 'Pedido en barra', FALSE, 'pendiente', 'efectivo'),
       (1, 2, 'servida', 'Evento privado', FALSE, 'completado', 'efectivo'),
       (1, 3, 'pendiente', 'Alergia a nueces', FALSE, 'pendiente', 'tarjeta'),
       (1, 5, 'preparando', 'Para llevar', FALSE, 'pendiente', 'efectivo'),
       (1, 7, 'servida', 'Cumpleaños', TRUE, 'completado', 'tarjeta'),
       (1, NULL, 'pendiente', 'Pedido en barra 2', FALSE, 'pendiente', 'efectivo'),
       (1, 9, 'cancelada', 'Error en pedido', FALSE, 'cancelado', 'tarjeta'),
       (1, 13, 'pendiente', 'Sin sal', FALSE, 'pendiente', 'efectivo'),
       (1, 15, 'preparando', 'Extra picante', TRUE, 'pendiente', 'tarjeta'),
       (1, 17, 'servida', 'Celebración', FALSE, 'completado', 'efectivo');

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
       (1, 'Vino Tinto', 3, 50.0, 10.00, 10.0, FALSE),
       (1, 'Pasta', 1, 20.0, 2.00, 5.0, FALSE),
       (1, 'Huevo', 3, 100.0, 0.20, 20.0, FALSE),
       (1, 'Pancetta', 1, 10.0, 5.00, 2.0, FALSE),
       (1, 'Queso Parmesano', 1, 15.0, 4.00, 3.0, FALSE),
       (1, 'Carne Molida', 1, 25.0, 3.50, 5.0, FALSE),
       (1, 'Cebolla', 1, 30.0, 1.00, 10.0, FALSE),
       (1, 'Ajo', 4, 5.0, 0.50, 1.0, FALSE),
       (1, 'Pimiento', 1, 20.0, 1.50, 5.0, FALSE),
       (1, 'Champiñones', 1, 15.0, 2.00, 3.0, FALSE),
       (1, 'Pepperoni', 1, 10.0, 4.50, 2.0, FALSE),
       (1, 'Café', 4, 500.0, 0.10, 100.0, FALSE),
       (1, 'Cacao en Polvo', 4, 200.0, 0.15, 50.0, FALSE),
       (1, 'Mascarpone', 1, 5.0, 6.00, 1.0, FALSE),
       (1, 'Azúcar', 1, 10.0, 1.00, 2.0, FALSE),
       (1, 'Leche', 2, 20.0, 1.20, 5.0, FALSE),
       (1, 'Crema', 2, 10.0, 2.50, 2.0, FALSE),
       (1, 'Helado de Vainilla', 2, 5.0, 3.00, 1.0, FALSE),
       (1, 'Cerveza', 3, 50.0, 1.50, 10.0, FALSE),
       (1, 'Refresco', 3, 100.0, 1.00, 20.0, FALSE),
       (1, 'Salsa Bolognesa', 2, 10.0, 3.00, 2.0, TRUE);

-- Relación Ingredientes Compuestos
INSERT INTO rel_ingredient_ingredients (parent_ingredient_id, component_ingredient_id, quantity, unit_id)
VALUES (6, 2, 0.5, 1),
       (6, 4, 0.1, 2),
       (7, 1, 1.0, 1),
       (7, 4, 0.2, 2),
       (29, 14, 0.5, 1),
       (29, 2, 1.0, 1),
       (29, 15, 0.2, 1),
       (29, 16, 10.0, 4);

-- Relación Ingredientes-Atributos
INSERT INTO rel_ingredients_attributes (ingredient_id, attribute_id)
VALUES (1, 1),
       (3, 7),
       (7, 1),
       (9, 12),
       (10, 1),
       (11, 3),
       (13, 7),
       (22, 7),
       (24, 7),
       (25, 7),
       (26, 7),
       (26, 3),
       (27, 1);


-- Productos
INSERT INTO products (name, restaurant_id, price, available, is_kitchen, category_id, description)
VALUES ('Bruschetta', 1, 3.00, TRUE, TRUE, 1,
        'Tostadas de pan rústico con tomate fresco, albahaca y aceite de oliva virgen extra.'),
       ('Pizza Margarita', 1, 7.00, TRUE, TRUE, 2,
        'Pizza clásica con salsa de tomate, mozzarella fresca y hojas de albahaca.'),
       ('Pizza Pepperoni', 1, 8.00, TRUE, TRUE, 2,
        'Pizza con salsa de tomate, mozzarella y rodajas de pepperoni picante.'),
       ('Spaghetti Carbonara', 1, 6.00, TRUE, TRUE, 2,
        'Pasta larga con salsa cremosa de huevo, pancetta, queso parmesano y pimienta negra.'),
       ('Lasagna', 1, 9.00, TRUE, TRUE, 2,
        'Capas de pasta con salsa bolognesa, bechamel, mozzarella y parmesano, horneada al punto.'),
       ('Tiramisú', 1, 4.00, TRUE, TRUE, 4,
        'Postre italiano con capas de mascarpone, café, bizcocho y cacao en polvo.'),
       ('Gelato', 1, 3.00, TRUE, TRUE, 4, 'Helado artesanal italiano, disponible en varios sabores cremosos.'),
       ('Agua Mineral', 1, 0.50, TRUE, FALSE, 5, 'Agua mineral natural, con o sin gas, refrescante y ligera.'),
       ('Vino Tinto', 1, 10.00, TRUE, FALSE, 5,
        'Vino tinto de la casa, equilibrado y perfecto para acompañar pastas y pizzas.'),
       ('Pizza Cuatro Estaciones', 1, 9.00, TRUE, TRUE, 2,
        'Pizza con mozzarella, champiñones, alcachofas, jamón y aceitunas, dividida en cuatro secciones.'),
       ('Pasta con Salsa de Tomate', 1, 5.00, TRUE, TRUE, 2,
        'Pasta al dente con salsa de tomate casera y un toque de albahaca.'),
       ('Pasta Bolognesa', 1, 7.00, TRUE, TRUE, 2,
        'Pasta con rica salsa de carne molida, tomate, cebolla y hierbas aromáticas.'),
       ('Panna Cotta', 1, 4.50, TRUE, TRUE, 4, 'Postre cremoso de nata con coulis de frutos rojos, suave y delicado.'),
       ('Cerveza', 1, 2.00, TRUE, FALSE, 5, 'Cerveza italiana refrescante, ideal para acompañar cualquier comida.'),
       ('Refresco', 1, 1.50, TRUE, FALSE, 5, 'Bebida carbonatada en varios sabores, perfecta para refrescar.'),
       ('Ensalada Caprese', 1, 4.00, TRUE, TRUE, 1,
        'Ensalada fresca con tomate, mozzarella de búfala, albahaca y aceite de oliva.'),
       ('Focaccia', 1, 3.50, TRUE, TRUE, 1, 'Pan plano italiano horneado con romero, sal marina y aceite de oliva.');

-- Relación Productos-Ingredientes
INSERT INTO rel_products_ingredients (product_id, ingredient_id, quantity)
VALUES (1, 2, 0.2),
       (1, 4, 0.05),
       (2, 7, 1.0),
       (2, 6, 0.3),
       (2, 3, 0.2),
       (3, 7, 1.0),
       (3, 6, 0.3),
       (4, 1, 0.3),
       (5, 1, 0.4),
       (6, 3, 0.1),
       (7, 3, 0.05),
       (8, 8, 1.0),
       (9, 9, 1.0),
       (10, 7, 1.0),
       (10, 6, 0.3),
       (10, 3, 0.2),
       (10, 18, 0.1),
       (10, 19, 0.1),
       (10, 17, 0.1),
       (11, 10, 0.2),
       (11, 6, 0.1),
       (12, 10, 0.2),
       (12, 29, 0.15),
       (13, 24, 0.1),
       (13, 25, 0.05),
       (13, 23, 0.02),
       (14, 27, 1.0),
       (15, 28, 1.0),
       (16, 2, 0.2),
       (16, 3, 0.15),
       (16, 5, 0.01),
       (16, 4, 0.05),
       (17, 1, 0.3),
       (17, 4, 0.1);


INSERT INTO rel_orders_products (order_id, product_id, price, notes, state)
VALUES (1, 1, 3.00, NULL, 'pendiente'),
       (1, 2, 7.00, 'Sin albahaca', 'pendiente'),
       (2, 3, 8.00, NULL, 'preparando'),
       (2, 4, 6.00, 'Extra pancetta', 'listo'),
       (3, 5, 9.00, NULL, 'listo'),
       (3, 6, 4.00, NULL, 'listo'),
       (4, 7, 3.00, NULL, 'cancelada'),
       (5, 8, 0.50, NULL, 'pendiente'),
       (5, 9, 10.00, NULL, 'pendiente'),
       (6, 2, 7.00, NULL, 'listo'),
       (6, 4, 6.00, NULL, 'listo'),
       (6, 6, 4.00, NULL, 'listo'),
       (7, 2, 7.00, NULL, 'pendiente'),
       (7, 4, 6.00, 'Sin huevo', 'pendiente'),
       (8, 10, 9.00, NULL, 'preparando'),
       (8, 11, 5.00, NULL, 'listo'),
       (9, 12, 7.00, NULL, 'listo'),
       (9, 13, 4.50, NULL, 'listo'),
       (10, 14, 2.00, NULL, 'pendiente'),
       (10, 15, 1.50, NULL, 'pendiente'),
       (11, 3, 8.00, NULL, 'cancelada'),
       (11, 5, 9.00, NULL, 'cancelada'),
       (12, 16, 4.00, NULL, 'pendiente'),
       (12, 8, 0.50, NULL, 'pendiente'),
       (13, 17, 3.50, 'Extra aceite', 'preparando'),
       (13, 9, 10.00, NULL, 'listo'),
       (14, 10, 9.00, NULL, 'listo'),
       (14, 6, 4.00, NULL, 'listo');