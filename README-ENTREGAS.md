## Decisiones de diseño:

###  **Entrega número dos:**
##### -  Creacion de comando Exports: 
 - El mismo permite solicitar las grillas pedidas por la catedra para exportar los turnos correspondientes a un dia o a una semana, con opcion a especifiar o no un professional.
 
##### -  Creacion de un directorio Templates. El cual contiene: 
  - *export_day: * Archivo del tipo html.erb, utilizado por Exports para visualizar la grilla de un dia especifico.
  - *export_week*: Archivo del tipo html.erb, utilizado por Exports para visualizar la grilla de una semana especifica.
  
##### -  Otras consideraciones: 
 - Se utilizó la librería ERB, para leer de un template y guardar el formato de la grilla solicitada.
 - Se asumio que los turnos ingresados respetan el rango de horario laboral de 10 a 21hs y son enviados usando bloque de 30 min. 
