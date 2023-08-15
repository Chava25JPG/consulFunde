import mysql.connector
import pandas as pd

def run_query(ci_user):
    connection = mysql.connector.connect(
        host="localhost",
        user="root",
        password="Zaragoza2525",
        database="funde"
    )

    if connection.is_connected():
        query = f"""
        SELECT
            u.CI_USER,
            u.NOM_USER,
            u.APE_PAT,
            u.APE_MAT,
            p.COD_PROGRA AS CODIGO_PROGRAMA,
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
                WHEN MAX(t.NOMBRE_TUTOR) IS NOT NULL AND MAX(t.NOMBRE_TUTOR) <> '' THEN 1
                ELSE 0
            END AS REGISTRADO_ELABORACION_TESIS,
            
            CASE
                WHEN (MAX(t.SUSTENTACION1) <> '' OR MAX(t.SUSTENTACION2) <> '' OR MAX(t.SUSTENTACION3) <> '') 
                     AND (t.SUSTENTACION1 IS NOT NULL OR t.SUSTENTACION2 IS NOT NULL OR t.SUSTENTACION3 IS NOT NULL) THEN '1'
                ELSE '0'
            END AS CONCLUIDO_ELABORO_TESIS,
            
            COALESCE(
                (SELECT CONCAT(SUBSTRING(usu.NOM_USER, 1, 1), SUBSTRING(usu.APE_PAT, 1, 1), SUBSTRING(usu.APE_MAT, 1, 1))
                 FROM usuario usu WHERE usu.CI_USER = t.NOMBRE_TUTOR), ''
            ) AS NOMBRE_TUTOR_INICIALES,
            
            CASE
                WHEN MAX(r.ci_user) IS NOT NULL THEN 1
                ELSE 0
            END AS ENVIO_REFRENDA,
            
            IFNULL(DATE_FORMAT(MAX(dr.fecha_fotocopia_ci_vigente), '%Y-%m-%d'), '0') AS FECHA_ENVIO_UNO_REFRENDA,
            
            CASE
                WHEN MAX(d.ci_user) IS NOT NULL THEN 1
                ELSE 0
            END AS HABILITACION_ENVIO_DEFENSA,
            
            IFNULL(DATE_FORMAT(MAX(dd.fecha_fotocopia_ci_vigente), '%Y-%m-%d'), '0') AS FECHA_ENVIO_UNO_DEFENSA,

            IFNULL(DATE_FORMAT(MAX(t.FECHA_DEFENSA), '%Y-%m-%d'), '0') AS FECHA_DEFENSA_TESIS,
            IFNULL(MAX(t.VALOR_EVALUACION), '0') AS VALOR_EVALUACION_DEFENSA,
            
            CASE
                WHEN dt.ci_user IS NOT NULL THEN 1
                ELSE 0
            END AS TITULACION_ENTREGADO,
            
            IFNULL(DATE_FORMAT(MAX(dt.fecha_fotocopia_ci_vigente), '%Y-%m-%d'), '0') AS TITULACION_FECHA_UNO

        FROM usuario u
        LEFT JOIN tesis t ON u.CI_USER = t.CI_USER
        LEFT JOIN docs_refrenda r ON u.CI_USER = r.ci_user
        LEFT JOIN docs_defensa d ON u.CI_USER = d.ci_user
        LEFT JOIN docs_refrenda dr ON u.CI_USER = dr.ci_user
        LEFT JOIN docs_defensa dd ON u.CI_USER = dd.ci_user
        LEFT JOIN docs_titulacion dt ON u.CI_USER = dt.ci_user
        INNER JOIN matricula m ON u.CI_USER = m.CI_USER
        INNER JOIN programa p ON m.COD_PROGRA = p.COD_PROGRA

        WHERE u.CI_USER = '{ci_user}'

        GROUP BY u.CI_USER, u.NOM_USER, u.APE_PAT, u.APE_MAT, p.COD_PROGRA;
        """
        
        results = pd.read_sql_query(query, connection)
        connection.close()
        return results

if __name__ == "__main__":
    ci_user = input("Ingrese el CI_USER del usuario que desea consultar: ")
    query_results = run_query(ci_user)
    
    if not query_results.empty:
        print(query_results)
    else:
        print("No se encontraron resultados.")
