require('chaitea-framework')

CT_Infusion {
	sqlite3 : require('sqlite3').verbose()
}

CT_Routes -> CT_StartServer()