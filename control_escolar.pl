
% SISTEMA GESTOR ESCOLAR EN PROLOG


% ----- BASE DE CONOCIMIENTO -----

% alumno(ID, Nombre). % son 5 alumnos creados para esta ocacion
alumno(1, 'Ana Perez').
alumno(2, 'Luis Gomez').
alumno(3, 'Sofia Rivera').
alumno(4, 'Miguel Garcia').
alumno(5, 'Fernanda Martinez').

% materia(Codigo, Nombre). % creamos los nombres de la materia y su respectivo ID 
materia(mat101, 'Matematicas').
materia(fis102, 'Fisica').
materia(pro103, 'Programacion').
materia(eti104, 'Etica').
materia(his105, 'Historia').
materia(ing106, 'Ingles').

% calificacion(IDAlumno, CodigoMateria, Calificacion).
calificacion(1, mat101, 90).
calificacion(1, fis102, 85).
calificacion(1, pro103, 85).
calificacion(1, eti104, 60).
calificacion(1, his105, 78).
calificacion(1, ing106, 88).

calificacion(2, mat101, 70).
calificacion(2, fis102, 85).
calificacion(2, pro103, 80).
calificacion(2, eti104, 75).
calificacion(2, his105, 95).
calificacion(2, ing106, 91).

calificacion(3, mat101, 105).  % Calificación inválida ya que no esta dentro del campo de calificaciones
calificacion(3, fis102, 95).
calificacion(3, pro103, 100).
calificacion(3, his105, 93).
calificacion(3, ing106, 97).

calificacion(4, mat101, 65).
calificacion(4, fis102, 85).
calificacion(4, pro103, 80).
calificacion(4, eti104, 70).
calificacion(4, his105, 50).
calificacion(4, ing106, 75).

calificacion(5, mat101, 95).
calificacion(5, fis102, 95).
calificacion(5, pro103, 95).
calificacion(5, eti104, 100).
calificacion(5, his105, 98).
calificacion(5, ing106, 100).

% ----- VALIDACIONES -----

alumno_existe(ID) :- alumno(ID, _).
materia_existe(Cod) :- materia(Cod, _).
calificacion_valida(C) :- number(C), C >= 0, C =< 100.

% ----- ASIGNACIÓN DE ESTATUS SEGÚN PROMEDIO -----

estatus(Prom, 'Excelente') :- Prom >= 90.
estatus(Prom, 'Notable') :- Prom >= 80, Prom < 90.
estatus(Prom, 'Aceptable') :- Prom >= 70, Prom < 80.
estatus(Prom, 'Deficiente') :- Prom >= 60, Prom < 70.
estatus(Prom, 'Insuficiente') :- Prom < 60.

% ----- CONSULTAS -----

% CONSULTAR POR ALUMNO
consultar_por_alumno(ID) :-
    alumno_existe(ID),
    alumno(ID, Nombre),
    format('📘 Calificaciones de ~w:~n', [Nombre]),
    forall(calificacion(ID, CodMat, Cal),
        (materia(CodMat, NomMat),
         (calificacion_valida(Cal) ->
            format('  ~w: ~w~n', [NomMat, Cal])
         ;
            format('  ~w: ~w (¡ERROR: Calificación inválida!)~n', [NomMat, Cal])
         ))), !.

consultar_por_alumno(_) :-
    writeln('❌ Error: Alumno no encontrado.').

% CONSULTAR POR MATERIA
consultar_por_materia(CodMat) :-
    materia_existe(CodMat),
    materia(CodMat, NomMat),
    format('📗 Alumnos con calificación en ~w:~n', [NomMat]),
    forall(calificacion(ID, CodMat, Cal),
        (alumno(ID, Nombre),
         (calificacion_valida(Cal) ->
            format('  ~w: ~w~n', [Nombre, Cal])
         ;
            format('  ~w: ~w (¡ERROR: Calificación inválida!)~n', [Nombre, Cal])
         ))), !.

consultar_por_materia(_) :-
    writeln('❌ Error: Materia no encontrada.').

% CONSULTAR PROMEDIO Y ESTATUS
consultar_promedio(ID) :-
    alumno_existe(ID),
    findall(Cal, (calificacion(ID, _, Cal), calificacion_valida(Cal)), Califs),
    length(Califs, N),
    (N > 0 ->
        sum_list(Califs, Total),
        Promedio is Total / N,
        estatus(Promedio, Estatus),
        alumno(ID, Nombre),
        format('📊 Promedio de ~w: ~2f~n', [Nombre, Promedio]),
        format('🎖️ Estatus: ~w~n', [Estatus])
    ;
        writeln('⚠️ No hay calificaciones válidas para calcular promedio.')
    ), !.

consultar_promedio(_) :-
    writeln('❌ Error: Alumno no encontrado.').
