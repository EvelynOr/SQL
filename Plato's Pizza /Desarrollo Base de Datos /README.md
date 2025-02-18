# Desarrollo Base de Datos 
Implementación y Gestión de Bases de Datos para la Administración de Información


#### Objetivo 
Desarrollar una propuesta de base de datos para la gestión de la información de un proyecto de venta de pizza. Se detallan los pasos realizados para analizar y modificar las tablas originales, crear nuevas tablas y asegurar la integridad y normalización de los datos.

#### Contenido 


### 1. Descripción, Evaluación  y Propuesta de Mejoras de Tablas Existente 
Tabla 1: order_details   
Columnas: order_details_id, order_id, pizza_id, quantity.

Revisión:

•	La tabla parece estar bien estructurada con una clave primaria (order_details_id) y referencias a order_id y pizza_id.

•	El tipo de datos parece adecuado, con quantity como número.

Claves:

•  order_details_id es la clave primaria.

•  order_id y pizza_id deberían ser claves foráneas que referencian las tablas orders y pizzas respectivamente.

Mejoras Propuestas:

•  Asegurarse de que order_id y pizza_id tengan restricciones de claves foráneas adecuadas para mantener la integridad referencial.

•  Verificar que quantity sea de tipo numérico, preferiblemente INTEGER.


