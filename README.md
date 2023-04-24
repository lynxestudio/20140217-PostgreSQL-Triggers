# Utilizando triggers en PostgreSQL

Adicionalmente a la utilización de reglas o constraints, existe otra forma de verificar y mantener la integridad en el DBMS para las aplicaciones, esto se logra mediante los triggers (disparadores). Un trigger es básicamente un store procedure o una función del lado del servidor que se dispara cuando una determinada acción INSERT,UPDATE o DELETE se ejecuta cada vez que una fila es modificada.

Aunque los triggers sirven en su mayoría para mantener la integridad de la base de datos también pueden usarse para:

Auditoría: Los triggers pueden usarse para llenar tablas de auditoría, en donde se registren ciertos tipos de transacciones o accesos hacia tablas.
Seguridad: Los triggers refuerzan las reglas de seguridad de una aplicación.
Reglas de negocio: Cuando ciertas reglas de negocio son muy elaboradoras y necesitan ser expresadas a nivel base de datos, es necesario que además de reglas y constraints se utilicen triggers.
Validación de datos: Los triggers pueden controlar ciertas acciones, por ejemplo: pueden rechazar o modificar ciertos valores que no cumplan determinadas reglas, para prevenir que datos inválidos sean insertados en la base.
A continuación un ejemplo de la utilización de triggers en postgreSQL.

Existe una tabla de facturas como la siguiente:



Creamos unas facturas con el siguiente script.



Bien esta tabla ya cuenta con algunos registros.



Ahora se necesita conocer aquellos registros que por error o intencionalmente cambiaron de fecha o de cantidad. Para cumplir con este requerimiento se crea una tabla en donde se guardará el historial de esos cambios.



Necesitamos una solución para que cada vez que se borre o se actualice un registro en la tabla invoices se registren los cambios en invoices_audit. Bien ya tenemos una razón para crear un trigger.

Antes de utilizar un trigger es indispensable crear una función trigger (trigger function) la cual es similar a un store procedure aunque un poco más restringida y con el acceso a unas variables predefinidas que contienen los valores de la fila que ejecuta el trigger, dependiendo de la operación estas variables son:

NEW En la operación INSERT representa el registro que se va a crear, en la operación UPDATE representa el valor del registro después de la actualización.
OLD En la operación UPDATE representa el valor antes de la actualización, en la operación DELETE representa el registro que se borrará.
TG_NAME El nombre del trigger.
TG_WHEN El instante en el cual se ejecutará el trigger, los valores son BEFORE o AFTER.
TG_OP La acción que dispara el trigger: INSERT, UPDATE o DELETE.
TG_RELNAME El nombre de la tabla que disparó el trigger.
TG_RELID El OID de la tabla que disparó el trigger
Esta trigger function se crea sin parámetros y con un valor de retorno de tipo trigger, esta función se ejecutará cada vez que una fila es modificada, a continuación el código de la función en donde se muestra el uso de variables predefinidas.



Siendo lo más importante a continuación el código que crea el trigger , esto es lo que asocia la tabla con la ejecución de la función.

La sintaxis general para crear un trigger es:

CREATE TRIGGER [name] [BEFORE | AFTER] [action]
ON [table] FOR EACH ROW
EXECUTE PROCEDURE [function name(arguments)]
  
El código completo es el siguiente:



Cuando ejecutemos el código de la función trigger y de la creación del trigger desde un archivo, PostgreSQL nos mostrará los siguientes mensajes:

  CREATE FUNCTION
CREATE TRIGGER
  
Observamos que la función trigger y el trigger se crearon exitosamente, utilizando PgAdmin III.


Probamos el trigger actualizando un par de registros en la tabla invoices.



Comprobamos que las actualizaciones se realizaron.



Por último mostramos los registros de la tabla invoices_audit, para comprobar que el trigger guardo los valores que cambiaron de los registros actualizados.
