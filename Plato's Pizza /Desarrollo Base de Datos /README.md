# Desarrollo Base de Datos 
Implementación y Gestión de Bases de Datos para la Administración de Información


#### Objetivo 
Desarrollar una propuesta de base de datos para la gestión de la información de un proyecto de venta de pizza. Se detallan los pasos realizados para analizar y modificar las tablas originales, crear nuevas tablas y asegurar la integridad y normalización de los datos.

#### Contenido 

#

### 1. Descripción, Evaluación  y Propuesta de Mejoras de Tablas Existente 
###### Tabla 1: order_details   
Columnas: order_details_id, order_id, pizza_id, quantity.

Revisión:

•	La tabla parece estar bien estructurada con una clave primaria (order_details_id) y referencias a order_id y pizza_id.

•	El tipo de datos parece adecuado, con quantity como número.

•  order_id y pizza_id deberían ser claves foráneas que referencian las tablas orders y pizzas respectivamente.

Mejoras Propuestas:

•  Asegurarse de que order_id y pizza_id tengan restricciones de claves foráneas adecuadas para mantener la integridad referencial.

•  Verificar que quantity sea de tipo numérico, preferiblemente INTEGER.
 
###### Tabla 2: orders

Columnas: order_id, date, time.

Revisión:

•	order_id parece ser la clave primaria.

•  date y time están separadas.

•	date y time se podrían combinar en una sola columna datetime para simplificar consultas.

Mejoras Propuestas:

Combinar date y time en una única columna datetime para simplificar consultas y análisis.

###### Tabla 3: pizza_types

Columnas: pizza_type_id, name, category, ingredients.

Revisión:
•	pizza_type_id como clave primaria.

Mejoras Propuestas:

•  Crear una nueva tabla pizza_ingredients con columnas pizza_id e ingredient para normalizar la lista de ingredientes.

•  Eliminar la columna ingredients de la tabla pizza_types.

###### Tabla 4: pizzas

Columnas: pizza_id, pizza_type_id, size, price.

Revisión:

•	pizza_id como clave primaria.

•	Relación directa con pizza_type_id.

• pizza_type_id es una clave foránea que referencia pizza_types.

Mejoras Propuestas:

•  Asegurarse de que pizza_type_id tenga una restricción de clave foránea para mantener la integridad referencial.

•  Verificar que price sea de tipo numérico, preferiblemente DECIMAL o FLOAT.




#

### 2. Tablas Adicionales
###### Tabla: ingredients

Columnas: ingredient_code, ingredient

Claves:

ingredient_code es la clave primaria.

Sin Claves Foráneas directamente, pero será referenciada por la tabla pizza_ingredients.


###### Tabla: pizza_ingredients
Columnas: pizza_id, ingredient, ingredient_code

Claves:

•  La clave primaria compuesta estará formada por pizza_id y ingredient_code.

•  pizza_id será una clave foránea que referencia la tabla pizzas.

•  ingredient_code será una clave foránea que referencia la tabla ingredients.

