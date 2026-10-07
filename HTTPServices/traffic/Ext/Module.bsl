//© vasilkov.vv 
// универсальный обмен данными через http service
// ничего не менять!
function msg(query)
	server=query.ПараметрыURL["server"];
	func=query.ПараметрыURL["function"];
	if server="localhost" then  //локальное выполнение
		try return DMS_DataExchange.success(eval(func+"(query)"),false) 
		except return DMS_DataExchange.refuse(func,ErrorDescription(),false) endtry
	else //переадресация
		if metadata.name="Gate" then //только на gate
			dataIn="";
			return ?( 
				DMS_DataExchange.sendMessage(
					DMS_ОбщиеПовторныеФункции.ПараметрыHTTPСоединения(server), //параметры соединения
					, //получатель пакета localhost. переадресуемые сообщения больше никуда не переадресуются
					func, //функция обработчик пакета на стороне получателя
					query.GetBodyAsString(), //DMS_DataExchange.newPackage(query.GetBodyAsString(),0), //переадресуемые данные, дополнительно не шифруются
					dataIn, //ответ сервера
					true), //признак переадресации
				DMS_DataExchange.success(dataIn,true), // ответ успех
				DMS_DataExchange.refuse(func,dataIn,true) //ответ отказ
			)
		else return DMS_DataExchange.refuse(func,"Попытка переадресации сообщения с "+metadata.name,false) //ашыпка тут!
		endif	
	endif	
endfunction