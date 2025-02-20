# Desarrollo Base de Datos 
Implementación y Gestión de Bases de Datos para la Administración de Información


#### Objetivo 
Desarrollar una propuesta de base de datos para la gestión de la información de un proyecto de venta de pizza. Se detallan los pasos realizados para analizar y modificar las tablas originales y propuesta de nuevas tablas. 

#### Contenido 

#

### 1. Descripción, Evaluación  y Propuesta de Mejoras de Tablas Existente 
###### Tabla 1: order_details   
Lleva el registro del detalle de cada orden/pedido hecho a la pizzería.
Columnas: order_details_id, order_id, pizza_id, quantity.

Revisión:

•	La tabla parece estar bien estructurada con una clave primaria (order_details_id) y referencias a order_id y pizza_id.

•	El tipo de datos parece adecuado, con quantity como número.

• order_id y pizza_id deberían ser claves foráneas que referencian las tablas orders y pizzas respectivamente.

Mejoras:

•  Asegurarse de que order_id y pizza_id tengan restricciones de claves foráneas adecuadas para mantener la integridad referencial.

•  Verificar que quantity sea de tipo numérico, preferiblemente INTEGER.
 
###### Tabla 2: orders
LLeva el control de las ordenes por fecha y por hora. 

Columnas: order_id, date, time.

Revisión:

•	clave primaria: order_id

•  date y time están separadas.

No Mejoras 


###### Tabla 3: pizza_types
Contiene el catálogo del tipo de pizzas que ofrece el restaurant. 

Columnas: pizza_type_id, name, category, ingredients.

Revisión:
•	clave primaria: pizza_type_id.

Mejoras:

•  Crear una nueva tabla pizza_ingredients con columnas pizza_id, ingredient_id, ingredient_quantity, para normalizar la lista de ingredientes.

•  Eliminar la columna ingredients de la tabla pizza_types.

###### Tabla 4: pizzas
Tiene el catálogo de los tamaños de cada pizza que se ofrece.

Columnas: pizza_id, pizza_type_id, size, price.

Revisión:

•	clave primaria: pizza_id.

•	Relación directa con pizza_type_id

• pizza_type_id es una clave foránea que referencia pizza_types.

Mejoras:

•  Asegurarse de que pizza_type_id tenga una restricción de clave foránea para mantener la integridad referencial.

•  Verificar que el campo price sea de tipo numérico, MONEY.

#

### 2. Tablas propuestas para la mejora en la gestión de los datos (Tablas Adicionales) 
###### Tabla: ingredients
Contiene el catálogo  de los ingredientes que lleva cada pizza.

Columnas: ingredient_id, ingredient_name

Claves:

• clave primaria: ingredient_id

• Sin Claves Foráneas directamente, pero será referenciada por la tabla pizza_ingredients.



###### Tabla: pizza_ingredients
Lleva el registro de los ingredientes y cantidad de ingrediente que lleva cada pizza.

Columnas: pizza_id, ingredient_id, ingredient_quantity

Claves:

• pizza_id e ingredient_id serán claves foráneas que referencian la tabla pizza_types y tabla ingredients.

