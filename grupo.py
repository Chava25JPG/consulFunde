import pandas as pd
import mysql.connector

# Configuración de la conexión a la base de datos
config = {
    "user": "root",
    "password": "Zaragoza2525",
    "host": "localhost",
    "database": "funde"
}

# Pide al usuario que ingrese el código del programa manualmente
codigo_programa = input("Ingresa el código del programa: ")

# Consulta SQL
query = f'''
SELECT
    u.CI_USER,
    u.NOM_USER,
    u.APE_PAT,
    u.APE_MAT,
    CASE
        WHEN t.CI_USER IS NOT NULL THEN '1'
        ELSE '0'
    END AS CONCLUSION_MALLA,

    CASE
        WHEN MAX(t.NOMBRE_GUIA) IS NOT NULL THEN 1
        ELSE 0
    END AS REGISTRADO_PROTOCOLO_TESIS,
    
    CASE
        WHEN MAX(t.EVALUACION) = 'SUFICIENTE' THEN 1
        ELSE 0
    END AS APROBADO,
    
    CASE
        WHEN MAX(t.NOMBRE_TUTOR) IS NOT NULL THEN 1
        ELSE 0
    END AS REGISTRADO_ELABORACION_TESIS,
    
    CASE
        WHEN MAX(t.SUSTENTACION1) IS NOT NULL AND MAX(t.SUSTENTACION2) IS NOT NULL AND MAX(t.SUSTENTACION3) IS NOT NULL THEN '1'
        WHEN MAX(t.SUSTENTACION1) IS NOT NULL OR MAX(t.SUSTENTACION2) IS NOT NULL OR MAX(t.SUSTENTACION3) IS NOT NULL THEN '1'
        ELSE '0'
    END AS ELABORO_TESIS,

    CASE
        WHEN MAX(r.ci_user) IS NOT NULL THEN 1
        ELSE 0
    END AS ENVIO_REFRENDA,
    
    CASE
        WHEN MAX(d.ci_user) IS NOT NULL THEN 1
        ELSE 0
    END AS HABILITACION_ENVIO_DEFENSA,

    MAX(t.FECHA_DEFENSA) AS FECHA_DEFENSA_TESIS,
    MAX(t.VALOR_EVALUACION) AS VALOR_EVALUACION_DEFENSA

FROM usuario u
LEFT JOIN tesis t ON u.CI_USER = t.CI_USER AND t.COD_PROGRAMA = '{codigo_programa}'
LEFT JOIN docs_refrenda r ON u.CI_USER = r.ci_user
LEFT JOIN docs_defensa d ON u.CI_USER = d.ci_user
INNER JOIN matricula m ON u.CI_USER = m.CI_USER AND m.COD_PROGRA = '{codigo_programa}'

GROUP BY u.CI_USER, u.NOM_USER, u.APE_PAT, u.APE_MAT
'''

# Conexión a la base de datos
conn = mysql.connector.connect(**config)

# Ejecutar la consulta y crear el DataFrame con los resultados
df = pd.read_sql_query(query, conn)

# Cerrar la conexión a la base de datos
conn.close()

# Mostrar el DataFrame como una tabla
print(df)
