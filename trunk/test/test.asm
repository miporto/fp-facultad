					.begin
					.org 2048

LECTURA:			ld		[PORT],%r1		! Guardo en %r1 lo que leo del puerto.
					andcc	%r1,1,%r2		! %r2 <- (%r1 AND 1), enmascaro el bit del nivel m�nimo. Si da 1, es porque el agua se encuentra por debajo del nivel m�nimo.
					be		COMPARO_N_MAX	! Si el agua no est� por debajo del nivel m�nimo, comparo el nivel m�ximo
					ba		N_MIN			! sino, apago el motor

COMPARO_N_MAX:		andcc	%r1,2,%r2		! Enmascaro el bit del nivel m�ximo. Si da 1, es porque se super� el nivel m�ximo.
					bne		APAGO_MOTOR		! Se super� el nivel m�ximo, entonces apago el motor
					ba		LECTURA			! Si no se super�, vuelvo a leer esperando cambios.

N_MIN:				andcc	%r1,4,%r2		! Enmascaro el bit de HAY_AGUA. Si da 1, es porque no se pas� el l�mite inferior del agua en el reservorio
					be		PRENDO_LUZ_ROJA	! Si no hay agua, prendo la luz roja. Si se alcanz� el nivel m�nimo, el motor estaba apagado, por eso no lo apago.
					ba		PRENDO_MOTOR	! Si hay agua, y se alcanz� el nivel m�nimo, prendo el motor

PRENDO_MOTOR:		andcc	%r1,64,%r2		! Enmascaro el bit de MOTOR, para ver en qu� estado est�
					be		PRENDO_MOTOR_2	! Si estaba apagado, lo prendo.
					ba		LECTURA			! Si ya estaba prendido (en 1), lo dejo y vuelvo a leer, para ver si se activa alg�n sensor.

PRENDO_MOTOR_2:		add		%r1,64,%r3		! Sabiendo que el motor est� apagado, lo prendo poni�ndolo en uno.
					st		%r3,[PORT]		! Y luego lo mando por el puerto
					ba		LECTURA

APAGO_MOTOR:		andcc	%r1,64,%r2		! Enmascaro el bit de MOTOR, para ver en qu� estado est�
					bne		APAGO_MOTOR_2	! Si estaba prendido, lo apago.
					ba		LECTURA			! Si ya estaba prendido (en 1), lo dejo y vuelvo a leer, para ver si se activa alg�n sensor.

APAGO_MOTOR_2:		sub		%r1,64,%r3		! Sabiendo que el motor est� prendido, lo apago poniendo en cero el bit correspondiente.
					st		%r3,[PORT]		! Y luego lo mando por el puerto
					ba		LECTURA

PRENDO_LUZ_ROJA:		andcc	%r1,32,%r2		! Enmascaro el bit de la luz roja, para ver en qu� estado est�
					be		PRENDO_LUZ_ROJA_2	! Si estaba apagada, la prendo.
					ba		LECTURA			! Si ya estaba prendido (en 1), lo dejo y vuelvo a leer, para ver si se activa alg�n sensor.

PRENDO_LUZ_ROJA_2:	add		%r1,32,%r3		! Sabiendo que la luz est� apagada, la prendo.
					st		%r3,[PORT]		! Y luego lo mando por el puerto
					ba		LECTURA

PORT:				0x000000FF
					
					.end