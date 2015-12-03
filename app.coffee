require('chaitea-framework')

CT_Infusion {
	sqlite3 : require('sqlite3').verbose()
	meses : ['Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre']
	dias : ['Domingo','Lunes','Martes','Miércoles','Jueves','Viernes','Sábado']
}

CT_Routes -> CT_StartServer()