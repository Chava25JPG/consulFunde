

--DEFINITIVO CONCLUSION MALLA CURRICULAR
SELECT m.MATRICULA, COUNT(DISTINCT n.COD_UNI) AS unidades_cursadas, p.SESIONES
FROM matricula m
LEFT JOIN nota n ON m.MATRICULA = n.MATRICULA
JOIN programa p ON m.COD_PROGRA = p.COD_PROGRA
GROUP BY m.MATRICULA, p.SESIONES
HAVING COUNT(DISTINCT n.COD_UNI) = p.SESIONES  
--DEFINITIVO CONCLUSION MALLA CURRICULAR GRUPO DETERMINADO
SELECT u.CI_USER, u.NOM_USER, u.APE_PAT, u.APE_MAT
FROM usuario u
INNER JOIN tesis t ON u.CI_USER = t.CI_USER
WHERE t.COD_PROGRAMA = 'MESADLPZ1/20';

-- NO CONCLUYERON, GRUPO DETERMINADO
SELECT m.CI_USER, u.NOM_USER, u.APE_PAT, u.APE_MAT
FROM matricula m
LEFT JOIN tesis t ON m.CI_USER = t.CI_USER AND m.COD_PROGRA = t.COD_PROGRAMA
INNER JOIN usuario u ON m.CI_USER = u.CI_USER
WHERE m.COD_PROGRA = 'MESADLPZ1/20' AND t.CI_USER IS NULL;


--REGISTRADOS
SELECT u.CI_USER, u.NOM_USER, u.APE_PAT, u.APE_MAT
FROM usuario u
INNER JOIN tesis t ON u.CI_USER = t.CI_USER
WHERE t.NOMBRE_GUIA IS NOT NULL AND t.COD_PROGRAMA = 'MESADLPZ1/20';

-- NO REGISTRADOS

SELECT u.CI_USER, u.NOM_USER, u.APE_PAT, u.APE_MAT
FROM usuario u
LEFT JOIN tesis t ON u.CI_USER = t.CI_USER AND t.COD_PROGRAMA = 'MESADLPZ1/20'
WHERE t.NOMBRE_GUIA = '';

--APROVARON EL TALLER DE PROTOCOLO DE TESIS
SELECT u.CI_USER, u.NOM_USER, u.APE_PAT, u.APE_MAT
FROM usuario u
INNER JOIN tesis t ON u.CI_USER = t.CI_USER
WHERE t.COD_PROGRAMA = 'MESADLPZ1/20' AND t.EVALUACION = 'SUFICIENTE';
-- NO APROVARON EL TALLER DE PROTOCOLO DE TESIS
SELECT u.CI_USER, u.NOM_USER, u.APE_PAT, u.APE_MAT
FROM usuario u
INNER JOIN tesis t ON u.CI_USER = t.CI_USER
WHERE t.COD_PROGRAMA = 'MESADLPZ1/20' AND t.EVALUACION = 'INSUFICIENTE';

--registro elaboracion tesis
SELECT u.CI_USER, u.NOM_USER, u.APE_PAT, u.APE_MAT
FROM usuario u
INNER JOIN tesis t ON u.CI_USER = t.CI_USER
WHERE t.COD_PROGRAMA = 'MESADLPZ1/20' AND t.NOMBRE_TUTOR <> '';

--no se registraron
SELECT u.CI_USER, u.NOM_USER, u.APE_PAT, u.APE_MAT
FROM usuario u
LEFT JOIN tesis t ON u.CI_USER = t.CI_USER AND t.COD_PROGRAMA = 'MESADLPZ1/20'
WHERE (t.NOMBRE_TUTOR = '') AND (t.EVALUACION <> '');

SELECT u.CI_USER, u.NOM_USER, u.APE_PAT, u.APE_MAT
FROM usuario u
LEFT JOIN tesis t ON u.CI_USER = t.CI_USER AND t.COD_PROGRAMA = 'MESADLPZ1/20'
WHERE (t.NOMBRE_TUTOR = '') AND (t.EVALUACION = 'SUFICIENTE');

--conclusion de elaboracion de tesis
SELECT u.CI_USER, u.NOM_USER, u.APE_PAT, u.APE_MAT
FROM usuario u
INNER JOIN tesis t ON u.CI_USER = t.CI_USER
WHERE t.COD_PROGRAMA = 'MESADLPZ1/20' 
  AND t.NOMBRE_TUTOR <> ''
  AND t.EVALUACION IS NOT NULL AND t.EVALUACION <> ''
  AND t.SUSTENTACION1 IS NOT NULL AND t.SUSTENTACION1 <> ''
  AND t.SUSTENTACION2 IS NOT NULL AND t.SUSTENTACION2 <> ''
  AND t.SUSTENTACION3 IS NOT NULL AND t.SUSTENTACION3 <> '';

  -- no conluyeron elaboracion de tesis
  SELECT u.CI_USER, u.NOM_USER, u.APE_PAT, u.APE_MAT
FROM usuario u
LEFT JOIN tesis t ON u.CI_USER = t.CI_USER AND t.COD_PROGRAMA = 'MESADLPZ1/20'
WHERE (t.NOMBRE_TUTOR <> '') AND (

  t.SUSTENTACION1 = ''
  OR t.SUSTENTACION2 = ''
  OR t.SUSTENTACION3 = '');

--enviarion refrenda
SELECT u.CI_USER, u.NOM_USER, u.APE_PAT, u.APE_MAT
FROM usuario u
INNER JOIN tesis t ON u.CI_USER = t.CI_USER
INNER JOIN docs_refrenda r ON u.CI_USER = r.ci_user
WHERE t.COD_PROGRAMA = 'MESCER2/17'
  AND t.SUSTENTACION1 IS NOT NULL AND t.SUSTENTACION1 <> ''
  AND t.SUSTENTACION2 IS NOT NULL AND t.SUSTENTACION2 <> ''
  AND t.SUSTENTACION3 IS NOT NULL AND t.SUSTENTACION3 <> '';
--no enviaron refrenda

SELECT u.CI_USER, u.NOM_USER, u.APE_PAT, u.APE_MAT
FROM usuario u
INNER JOIN tesis t ON u.CI_USER = t.CI_USER
WHERE t.COD_PROGRAMA = 'MESADLPZ1/20'
  AND t.SUSTENTACION1 IS NOT NULL AND t.SUSTENTACION1 <> ''
  AND t.SUSTENTACION2 IS NOT NULL AND t.SUSTENTACION2 <> ''
  AND t.SUSTENTACION3 IS NOT NULL AND t.SUSTENTACION3 <> ''
  AND u.CI_USER NOT IN (
    SELECT ci_user FROM docs_refrenda
  );

--Defensa

SELECT u.CI_USER, u.NOM_USER, u.APE_PAT, u.APE_MAT
FROM usuario u
INNER JOIN tesis t ON u.CI_USER = t.CI_USER
INNER JOIN docs_refrenda r ON u.CI_USER = r.ci_user
LEFT JOIN docs_defensa d ON u.CI_USER = d.ci_user
WHERE t.COD_PROGRAMA = 'MESCER2/17'
  AND r.CI_USER IS NOT NULL;

-- no defensa

SELECT u.CI_USER, u.NOM_USER, u.APE_PAT, u.APE_MAT
FROM usuario u
INNER JOIN tesis t ON u.CI_USER = t.CI_USER
INNER JOIN docs_refrenda r ON u.CI_USER = r.ci_user
LEFT JOIN docs_defensa d ON u.CI_USER = d.ci_user
WHERE t.COD_PROGRAMA = 'MESCER2/17'
  AND d.CI_USER IS NULL;


--Fecha defensa tesis mostrar usuarios que si

SELECT u.CI_USER, u.NOM_USER, u.APE_PAT, u.APE_MAT, t.FECHA_DEFENSA
FROM usuario u
INNER JOIN tesis t ON u.CI_USER = t.CI_USER
INNER JOIN docs_defensa d ON u.CI_USER = d.ci_user
WHERE t.COD_PROGRAMA = 'MESCER2/17'
  AND t.FECHA_DEFENSA IS NOT NULL AND t.FECHA_DEFENSA <> '';


 

--Fecha defensa tesis mostrar usuarios que no


SELECT u.CI_USER, u.NOM_USER, u.APE_PAT, u.APE_MAT
FROM usuario u
INNER JOIN tesis t ON u.CI_USER = t.CI_USER
LEFT JOIN docs_defensa d ON u.CI_USER = d.ci_user
WHERE t.COD_PROGRAMA = 'MESCER2/17'
  AND d.CI_USER IS NOT NULL
  AND (t.FECHA_DEFENSA IS NULL OR t.FECHA_DEFENSA = '');


--fecha de defensa con valor de evaluacion

SELECT u.CI_USER, u.NOM_USER, u.APE_PAT, u.APE_MAT, t.FECHA_DEFENSA, t.VALOR_EVALUACION
FROM usuario u
INNER JOIN tesis t ON u.CI_USER = t.CI_USER
WHERE t.COD_PROGRAMA = 'MESCER2/17'
  AND t.FECHA_DEFENSA IS NOT NULL AND t.FECHA_DEFENSA <> ''
  AND t.VALOR_EVALUACION IS NOT NULL AND t.VALOR_EVALUACION <> '';


--GRUPO EN UNA SOLA CONSULTA
SELECT
    u.CI_USER,
    u.NOM_USER,
    u.APE_PAT,
    u.APE_MAT,
    CASE
        WHEN EXISTS (
            SELECT 1
            FROM tesis t2
            WHERE t2.CI_USER = u.CI_USER
        ) THEN '1'
        ELSE '0'
    END AS CONCLUSION_MALLA,
    
    
    
    CASE WHEN MAX(t.NOMBRE_GUIA)IS NOT NULL THEN 1 ELSE 0 END AS REGISTRADO_PROTOCOLO_TESIS,
    CASE WHEN MAX(t.EVALUACION) = 'SUFICIENTE' THEN 1 ELSE 0 END AS APROBADO,
    CASE WHEN MAX(t.NOMBRE_TUTOR)IS NOT NULL THEN 1 ELSE 0 END AS REGISTRADO_ELABORACION_TESIS,
    CASE
        WHEN MAX(t.SUSTENTACION1) IS NOT NULL AND MAX(t.SUSTENTACION2) IS NOT NULL AND MAX(t.SUSTENTACION3) IS NOT NULL THEN '1'
        WHEN MAX(t.SUSTENTACION1) IS NOT NULL OR MAX(t.SUSTENTACION2) IS NOT NULL OR MAX(t.SUSTENTACION3) IS NOT NULL THEN '1'
        ELSE '0'
    END AS ELABORO_TESIS,
    
    CASE WHEN MAX(r.ci_user) IS NOT NULL THEN 1 ELSE 0 END AS ENVIO_REFRENDA,
    CASE WHEN MAX(d.ci_user) IS NOT NULL THEN 1 ELSE 0 END AS HABILITACION_ENVIO_DEFENSA,
    
    MAX(t.FECHA_DEFENSA) AS FECHA_DEFENSA_TESIS,
    MAX(t.VALOR_EVALUACION) AS VALOR_EVALUACION_DEFENSA
    
    
FROM usuario u
LEFT JOIN (
    SELECT *
    FROM tesis
    WHERE COD_PROGRAMA = 'MESCER2/17'
) t ON u.CI_USER = t.CI_USER
LEFT JOIN docs_refrenda r ON u.CI_USER = r.ci_user
LEFT JOIN docs_defensa d ON u.CI_USER = d.ci_user
LEFT JOIN matricula m ON u.CI_USER = m.CI_USER AND m.COD_PROGRA = 'MESCER2/17'
GROUP BY u.CI_USER, u.NOM_USER, u.APE_PAT, u.APE_MAT  




---------------------------------------------------------------------------------------------
SELECT
    u.CI_USER,
    u.NOM_USER,
    u.APE_PAT,
    u.APE_MAT,
    CASE
        WHEN EXISTS (
            SELECT 1
            FROM tesis t2
            WHERE t2.CI_USER = u.CI_USER
        ) THEN '1'
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
LEFT JOIN (
    SELECT *
    FROM tesis
    WHERE COD_PROGRAMA = 'MESCER2/17'
) t ON u.CI_USER = t.CI_USER
LEFT JOIN docs_refrenda r ON u.CI_USER = r.ci_user
LEFT JOIN docs_defensa d ON u.CI_USER = d.ci_user
LEFT JOIN matricula m ON u.CI_USER = m.CI_USER AND m.COD_PROGRA = 'MESCER2/17'

GROUP BY u.CI_USER, u.NOM_USER, u.APE_PAT, u.APE_MAT  
ORDER BY `VALOR_EVALUACION_DEFENSA`  DESC




---------------------------------GRAL
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
LEFT JOIN tesis t ON u.CI_USER = t.CI_USER AND t.COD_PROGRAMA = 'MESCER2/17'
LEFT JOIN docs_refrenda r ON u.CI_USER = r.ci_user
LEFT JOIN docs_defensa d ON u.CI_USER = d.ci_user
INNER JOIN matricula m ON u.CI_USER = m.CI_USER AND m.COD_PROGRA = 'MESCER2/17'
INNER JOIN programa p ON m.COD_PROGRA = p.COD_PROGRA;


----------------------------USUARIO
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
    MAX(t.VALOR_EVALUACION) AS VALOR_EVALUACION_DEFENSA,
    
    m.COD_PROGRA AS CODIGO_PROGRAMA

FROM usuario u
LEFT JOIN tesis t ON u.CI_USER = t.CI_USER
LEFT JOIN docs_refrenda r ON u.CI_USER = r.ci_user
LEFT JOIN docs_defensa d ON u.CI_USER = d.ci_user
LEFT JOIN matricula m ON u.CI_USER = m.CI_USER

WHERE u.CI_USER = '5205857'

GROUP BY u.CI_USER, u.NOM_USER, u.APE_PAT, u.APE_MAT, m.COD_PROGRA;



------------------------VAlor evaluacion >0
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
LEFT JOIN tesis t ON u.CI_USER = t.CI_USER AND t.COD_PROGRAMA = 'MESCER2/17'
LEFT JOIN docs_refrenda r ON u.CI_USER = r.ci_user
LEFT JOIN docs_defensa d ON u.CI_USER = d.ci_user
INNER JOIN matricula m ON u.CI_USER = m.CI_USER AND m.COD_PROGRA = 'MESCER2/17'

WHERE 
    m.COD_PROGRA = 'MESCER2/17'
    AND (t.VALOR_EVALUACION > 0 )

GROUP BY u.CI_USER, u.NOM_USER, u.APE_PAT, u.APE_MAT;





























































------------------------------------------------------------------------------------------------------------------------
------------------------------------DEFINITIVO----------------------------------------------------------------------


--grupo;
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
LEFT JOIN tesis t ON u.CI_USER = t.CI_USER AND t.COD_PROGRAMA = 'MESCER2/17'
LEFT JOIN docs_refrenda r ON u.CI_USER = r.ci_user
LEFT JOIN docs_defensa d ON u.CI_USER = d.ci_user
LEFT JOIN docs_refrenda dr ON u.CI_USER = dr.ci_user
LEFT JOIN docs_defensa dd ON u.CI_USER = dd.ci_user
LEFT JOIN docs_titulacion dt ON u.CI_USER = dt.ci_user
INNER JOIN matricula m ON u.CI_USER = m.CI_USER AND m.COD_PROGRA = 'MESCER2/17'

GROUP BY u.CI_USER, u.NOM_USER, u.APE_PAT, u.APE_MAT  





-----------------------------------------------------------------------------------------------------
---------------------------------USUARIO DADO----------------------------------------------------
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

WHERE u.CI_USER = '3773113' 

GROUP BY u.CI_USER, u.NOM_USER, u.APE_PAT, u.APE_MAT, p.COD_PROGRA;
