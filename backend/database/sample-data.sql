-- Inserciones para tablas maestras
-- Unidades de medida
INSERT INTO mt_units (name, symbol) VALUES
    ('Kilogramo', 'kg'),
    ('Litro', 'L'),
    ('Unidad', 'u'),
    ('Gramo', 'g'),
    ('Mililitro', 'ml'),
    ('Metro', 'm'),
    ('Centímetro', 'cm'),
    ('Docena', 'doc');

-- Roles (mantenidos como están, según tu solicitud)
INSERT INTO mt_roles (name) VALUES
    ('ROLE_ADMIN'),
    ('ROLE_SYSTEM'),
    ('ROLE_USER'),
    ('ROLE_OWNER'),
    ('ROLE_MANAGER'),
    ('ROLE_WAITER'),
    ('ROLE_COOK'),
    ('ROLE_CASHIER'),
    ('ROLE_DELIVERY');

-- Atributos
INSERT INTO mt_attributes (name, description) VALUES
    ('Sin gluten', 'Producto apto para celíacos'),
    ('Picante', 'Contiene ingredientes picantes'),
    ('Vegetariano', 'Apto para vegetarianos'),
    ('Vegano', 'Apto para veganos'),
    ('Contiene lactosa', 'Contiene productos lácteos'),
    ('Contiene frutos secos', 'Contiene almendras, nueces, etc.');

INSERT INTO payment_plans (name, description, monthly_price, max_users) VALUES
	('Básico', 'Ideal para pequeños negocios que necesitan gestionar mesas y pedidos de manera eficiente.', 9.99, 5),
	('Avanzado', 'Perfecto para negocios en expansión que requieren gestión de inventario y control adicional.', 24.99, 15),
	('Pro', 'Diseñado para negocios en crecimiento que buscan análisis predictivo y optimización operativa.', 39.99, 25),
	('Premium', 'Para grandes negocios o cadenas que necesitan todas las funciones y soporte prioritario.', 69.99, 35),
	('Personalizado', 'Plan a medida para necesidades específicas. Contáctanos para más detalles.', 0.00, NULL);

-- Restaurantes
INSERT INTO restaurants (name, address, cuisine_type, description, payment_plan_id, paid) VALUES
    ('La Trattoria', 'Calle Falsa 123, Ciudad', 'Italiana', 'Restaurante italiano con ambiente familiar y auténtica cocina italiana', 4, true);

-- Usuarios
INSERT INTO users (name, email, password_hash, role_id, phone, restaurant_id, verified) VALUES
    ('Admin', 'admin@trattoria.com', 'hash_admin', 1, '123456789', NULL, true), -- ROLE_ADMIN
    ('Propietario', 'owner@trattoria.com', 'hash_owner', 4, '987654321', 1, true), -- ROLE_OWNER
    ('Gerente', 'manager@trattoria.com', 'hash_manager', 5, '555555555', 1, true), -- ROLE_MANAGER
    ('Mesero1', 'waiter1@trattoria.com', 'hash_waiter1', 6, '666666666', 1, true), -- ROLE_WAITER
    ('Mesero2', 'waiter2@trattoria.com', 'hash_waiter2', 6, '777777777', 1, true), -- ROLE_WAITER
    ('Cocinero1', 'cook1@trattoria.com', 'hash_cook1', 7, '888888888', 1, true), -- ROLE_COOK
    ('Cocinero2', 'cook2@trattoria.com', 'hash_cook2', 7, '999999999', 1, true), -- ROLE_COOK
    ('Cajero', 'cashier@trattoria.com', 'hash_cashier', 8, '111111111', 1, true), -- ROLE_CASHIER
    ('Delivery', 'delivery@trattoria.com', 'hash_delivery', 9, '222222222', 1, true); -- ROLE_DELIVERY

-- Diseños
INSERT INTO layouts (restaurant_id, name) VALUES
    (1, 'Planta Baja'),
    (1, 'Terraza'),
    (1, 'Sala Privada');

-- Mesas
INSERT INTO tables (layout_id, number, state, capacity) VALUES
    (1, 1, 'available', 4),
    (1, 2, 'available', 4),
    (1, 3, 'available', 6),
    (1, 4, 'available', 2),
    (2, 1, 'available', 4),
    (2, 2, 'available', 4),
    (2, 3, 'available', 6),
    (3, 1, 'available', 8),
    (3, 2, 'available', 10);

-- Reservas
INSERT INTO reservations (restaurant_id, reserved_at, customer_name, customer_contact, number_of_people, state, notes) VALUES
    (1, '2023-10-20 19:00:00', 'Carlos Gómez', '555123456', 4, 'confirmed', 'Mesa cerca de la ventana'),
    (1, '2023-10-20 20:00:00', 'Ana Martínez', '555987654', 6, 'pending', 'Cumpleaños'),
    (1, '2023-10-21 18:30:00', 'Luis Rodríguez', '555111222', 2, 'confirmed', NULL);

INSERT INTO rel_reservation_tables (reservation_id, table_id) VALUES
    (1, 1),
    (2, 3),
    (3, 4);

-- Órdenes
INSERT INTO orders (restaurant_id, state, notes, urgent, payment_state, payment_method) VALUES
    (1, 'pending', 'Sin cebolla', FALSE, 'pending', 'cash'),
    (1, 'in_progress', 'Extra queso', FALSE, 'pending', 'card'),
    (1, 'served', 'Para llevar', FALSE, 'completed', 'mobile'),
    (1, 'pending', 'Sin gluten', TRUE, 'pending', 'voucher');

INSERT INTO rel_order_tables (order_id, table_id) VALUES
    (1, 1),
    (2, 2),
    (3, 3),
    (4, 4);

-- Categorías de menú
INSERT INTO menu_categories (restaurant_id, name) VALUES
    (1, 'Antipasti'),
    (1, 'Pizzas'),
    (1, 'Pastas'),
    (1, 'Postres'),
    (1, 'Bebidas'),
    (1, 'Ofertas');

-- Ingredientes
INSERT INTO ingredients (restaurant_id, name, unit_id, stock, cost_per_unit, min_stock, is_composite) VALUES
    (1, 'Harina', 1, 50.0, 2.50, 10.0, FALSE),
    (1, 'Tomate', 1, 30.0, 1.80, 5.0, FALSE),
    (1, 'Mozzarella', 1, 20.0, 3.50, 5.0, FALSE),
    (1, 'Aceite de oliva', 2, 10.0, 5.00, 2.0, FALSE),
    (1, 'Albahaca', 4, 100.0, 0.10, 20.0, FALSE),
    (1, 'Salsa de tomate', 2, 15.0, 2.00, 3.0, TRUE),
    (1, 'Masa para pizza', 3, 20.0, 1.50, 5.0, TRUE),
    (1, 'Agua Mineral', 3, 100.0, 0.50, 20.0, FALSE),
    (1, 'Vino Tinto', 3, 50.0, 10.00, 10.0, FALSE);

INSERT INTO rel_ingredient_ingredients (parent_ingredient_id, component_ingredient_id, quantity, unit_id) VALUES
    (6, 2, 0.5, 1), -- Salsa de tomate: 0.5 kg de tomate
    (6, 4, 0.1, 2), -- Salsa de tomate: 0.1 L de aceite de oliva
    (7, 1, 1.0, 1), -- Masa para pizza: 1 kg de harina
    (7, 4, 0.2, 2); -- Masa para pizza: 0.2 L de aceite de oliva

INSERT INTO rel_ingredient_attributes (ingredient_id, attribute_id) VALUES
    (1, 1), -- Harina sin gluten
    (3, 5), -- Mozzarella contiene lactosa
    (5, 4), -- Albahaca vegana
    (6, 4), -- Salsa de tomate vegana
    (7, 1); -- Masa para pizza sin gluten

-- Productos
INSERT INTO products (name, total_cost, available, is_kitchen) VALUES
    ('Bruschetta', 3.00, TRUE, TRUE),
    ('Pizza Margarita', 7.00, TRUE, TRUE),
    ('Pizza Pepperoni', 8.00, TRUE, TRUE),
    ('Spaghetti Carbonara', 6.00, TRUE, TRUE),
    ('Lasagna', 9.00, TRUE, TRUE),
    ('Tiramisú', 4.00, TRUE, TRUE),
    ('Gelato', 3.00, TRUE, TRUE),
    ('Agua Mineral', 0.50, TRUE, FALSE),
    ('Vino Tinto', 10.00, TRUE, FALSE);

INSERT INTO rel_product_ingredients (product_id, ingredient_id, quantity) VALUES
    (1, 2, 0.2), -- Bruschetta: 0.2 kg de tomate
    (1, 4, 0.05), -- Bruschetta: 0.05 L de aceite de oliva
    (2, 7, 1.0), -- Pizza Margarita: 1 unidad de masa para pizza
    (2, 6, 0.3), -- Pizza Margarita: 0.3 L de salsa de tomate
    (2, 3, 0.2), -- Pizza Margarita: 0.2 kg de mozzarella
    (3, 7, 1.0), -- Pizza Pepperoni: 1 unidad de masa para pizza
    (3, 6, 0.3), -- Pizza Pepperoni: 0.3 L de salsa de tomate
    (4, 1, 0.3), -- Spaghetti Carbonara: 0.3 kg de harina (pasta)
    (5, 1, 0.4), -- Lasagna: 0.4 kg de harina (pasta)
    (6, 3, 0.1), -- Tiramisú: 0.1 kg de mozzarella (queso)
    (7, 3, 0.05), -- Gelato: 0.05 kg de mozzarella (queso)
    (8, 8, 1.0), -- Agua Mineral: 1 unidad
    (9, 9, 1.0); -- Vino Tinto: 1 unidad

-- Menús
INSERT INTO menu_items (name, category_id, price) VALUES
    ('Bruschetta', 1, 5.00),
    ('Pizza Margarita', 2, 12.50),
    ('Pizza Pepperoni', 2, 14.00),
    ('Spaghetti Carbonara', 3, 13.00),
    ('Lasagna', 3, 15.00),
    ('Tiramisú', 4, 6.00),
    ('Gelato', 4, 4.50),
    ('Agua Mineral', 5, 2.00),
    ('Vino Tinto', 5, 8.00),
	('2x1 en Pizzas', 6, 12.50),       -- Precio de una pizza, la segunda gratis
    ('Combo Familiar', 6, 25.00),      -- Pizza, pasta y bebidas
    ('Oferta San Valentín', 6, 30.00); -- Especial para parejas

INSERT INTO rel_menu_item_products (menu_item_id, product_id, quantity) VALUES
    (1, 1, 1), -- Bruschetta
    (2, 2, 1), -- Pizza Margarita
    (3, 3, 1), -- Pizza Pepperoni
    (4, 4, 1), -- Spaghetti Carbonara
    (5, 5, 1), -- Lasagna
    (6, 6, 1), -- Tiramisú
    (7, 7, 1), -- Gelato
    (8, 8, 1), -- Agua Mineral
    (9, 9, 1), -- Vino Tinto
    (10, 2, 1), -- 1 Pizza Margarita
    (10, 3, 1), -- 1 Pizza Pepperoni (gratis)
	(11, 2, 1), -- 1 Pizza Margarita
    (11, 4, 1), -- 1 Spaghetti Carbonara
    (11, 8, 2); -- 2 Agua Mineral

INSERT INTO menus (restaurant_id, name, description, active_from, active_to) VALUES
    (1, 'Menú del Día', 'Oferta diaria con entrada, plato principal y postre', '12:00:00', '15:00:00'),
    (1, 'Menú Infantil', 'Platos pequeños para niños', '11:00:00', '20:00:00'),
	(1, 'Menú de Ofertas', 'Ofertas especiales disponibles todo el día', '00:00:00', '23:59:59');

INSERT INTO rel_menus_menu_items (menu_id, menu_item_id) VALUES
    (1, 1), -- Menú del Día: Bruschetta
    (1, 2), -- Menú del Día: Pizza Margarita
    (1, 6), -- Menú del Día: Tiramisú
    (2, 4), -- Menú Infantil: Spaghetti Carbonara
    (2, 7), -- Menú Infantil: Gelato
	(3, 10),  -- 2x1 en Pizzas
    (3, 11),  -- Combo Familiar
    (3, 12);  -- Oferta San Valentín

-- Ítems de pedido
INSERT INTO order_items (order_id, menu_item_id, price, notes, state) VALUES
    (1, 2, 12.50, 'Sin queso extra', 'waiting'),
    (1, 8, 2.00, NULL, 'waiting'),
    (2, 3, 14.00, 'Extra pepperoni', 'preparing'),
    (2, 9, 8.00, NULL, 'preparing'),
    (3, 1, 5.00, 'Con extra tomate', 'delivered'),
    (3, 5, 15.00, NULL, 'delivered'),
    (4, 4, 13.00, 'Sin gluten', 'waiting');

-- Retroalimentación
INSERT INTO feedback (order_id, rating, comment) VALUES
    (1, 4, 'Muy buena pizza, pero tardó un poco'),
    (2, 5, 'Excelente servicio y comida'),
    (3, 3, 'La bruschetta estaba fría'),
    (4, 4, 'Buena opción sin gluten');

-- Turnos
INSERT INTO shifts (name, restaurant_id, start_time, end_time) VALUES
    ('Turno Mañana', 1, '08:00:00', '14:00:00'),
    ('Turno Tarde', 1, '14:00:00', '20:00:00'),
    ('Turno Noche', 1, '20:00:00', '02:00:00');

INSERT INTO rel_user_shifts (user_id, shift_id, shift_date) VALUES
    (4, 1, '2023-10-20'), -- Mesero1 en Turno Mañana
    (5, 2, '2023-10-20'), -- Mesero2 en Turno Tarde
    (6, 1, '2023-10-20'), -- Cocinero1 en Turno Mañana
    (7, 3, '2023-10-20'), -- Cocinero2 en Turno Noche
    (8, 2, '2023-10-20'), -- Cajero en Turno Tarde
    (9, 3, '2023-10-20'); -- Delivery en Turno Noche