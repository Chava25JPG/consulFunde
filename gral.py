import pandas as pd
import mysql.connector

# Configuración de la conexión a la base de datos
config = {
    "user": "root",
    "password": "Zaragoza2525",
    "host": "localhost",
    "database": "funde"
}

# Pide al usuario que ingrese el código de programa
codigo_programa = input("Ingresa el código de programa: ")

# Consulta SQL para obtener el resumen general
query = f'''
SELECT
    COUNT(u.CI_USER) AS TOTAL_USUARIOS,
    SUM(CASE WHEN t.CI_USER IS NOT NULL THEN 1 ELSE 0 END) AS CONCLUSION_MALLA,
    SUM(CASE WHEN t.NOMBRE_GUIA IS NOT NULL THEN 1 ELSE 0 END) AS REGISTRADO_PROTOCOLO_TESIS,
    SUM(CASE WHEN t.EVALUACION = 'SUFICIENTE' THEN 1 ELSE 0 END) AS APROBADO,
    SUM(CASE WHEN t.NOMBRE_TUTOR IS NOT NULL THEN 1 ELSE 0 END) AS REGISTRADO_ELABORACION_TESIS,
    SUM(CASE WHEN t.SUSTENTACION1 IS NOT NULL OR t.SUSTENTACION2 IS NOT NULL OR t.SUSTENTACION3 IS NOT NULL THEN 1 ELSE 0 END) AS ELABORO_TESIS,
    SUM(CASE WHEN r.ci_user IS NOT NULL THEN 1 ELSE 0 END) AS ENVIO_REFRENDA,
    SUM(CASE WHEN d.ci_user IS NOT NULL THEN 1 ELSE 0 END) AS HABILITACION_ENVIO_DEFENSA,
    SUM(CASE WHEN t.FECHA_DEFENSA <> '' THEN 1 ELSE 0 END) AS TOTAL_FECHA_DEFENSA,
    SUM(CASE WHEN t.VALOR_EVALUACION >= p.APROVA THEN 1 ELSE 0 END) AS TOTAL_APROBADOS_EVALUACION
FROM usuario u
LEFT JOIN tesis t ON u.CI_USER = t.CI_USER AND t.COD_PROGRAMA = '{codigo_programa}'
LEFT JOIN docs_refrenda r ON u.CI_USER = r.ci_user
LEFT JOIN docs_defensa d ON u.CI_USER = d.ci_user
INNER JOIN matricula m ON u.CI_USER = m.CI_USER AND m.COD_PROGRA = '{codigo_programa}'
INNER JOIN programa p ON m.COD_PROGRA = p.COD_PROGRA;
'''

# Conexión a la base de datos
conn = mysql.connector.connect(**config)

# Ejecutar la consulta y crear el DataFrame con los resultados
df = pd.read_sql_query(query, conn)

# Cerrar la conexión a la base de datos
conn.close()

# Mostrar el resumen general en una tabla
print(df)
