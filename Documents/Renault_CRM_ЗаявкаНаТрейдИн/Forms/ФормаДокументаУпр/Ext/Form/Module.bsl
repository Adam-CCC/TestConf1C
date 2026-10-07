
&НаКлиенте
Процедура Команда1(Команда)
	Команда1НаСервере();
КонецПроцедуры

&НаСервере
Процедура Команда1НаСервере()
	
	//HTTPЗапрос = Новый HTTPЗапрос();
	//HTTPЗапрос.АдресРесурса = "/offers?mark=skoda&model=yeti&year_from=2013&year_to=2014&engine_type=GASOLINE&km_age_from=60000&displacement_from=1800&sort_offers=price-asc";
	//
	//HTTPЗапрос.Заголовки.Вставить("Content-Type", "application/xml");
	//HTTPЗапрос.Заголовки.Вставить("Accept", "application/xml");
	//// HTTPЗапрос.Заголовки.Вставить("Authorization", "Token 0fec28e16de3770fcac83b2615b37e7c4fadee38"); 
	////HTTPЗапрос.УстановитьТелоИзСтроки("<req><query>" + Текст + "</query></req>"); 

	//Соединение = Новый HTTPСоединение("auto.yandex.ru",,,,,, Новый ЗащищенноеСоединениеOpenSSL);
	//
	//ОтветHTTP = Соединение.ОтправитьДляОбработки(HTTPЗапрос);
	//
	//Тело = ОтветHTTP.ПолучитьТелоКакСтроку();
	//
	//Если ОтветHTTP.КодСостояния = 200 Тогда
	//               ЧтениеXML = Новый ЧтениеXML;
	//                ЧтениеXML.УстановитьСтроку(Тело);
	//               ЧтениеXML.ПерейтиКСодержимому();
	//               ОбъектXDTO = ФабрикаXDTO.ПрочитатьXML(ЧтениеXML);
	//               ЧтениеXML.Закрыть();
	//               стрЗначение = "";
	//			   //Если ОбъектXDTO.Свойства().Получить("suggestions") <> Неопределено Тогда
	//			   //                ОбработатьОтвет (мЗначения, ОбъектXDTO, ТипПодбора);
	//			   //КонецЕсли; 
	//КонецЕсли;
	
	Реквизит1 = "<html>
	|<head><title>Анкета</title></head>
	|<body><form name='anketa' action='input.asp'><table><tr><td>Организация</td><td><input type=text name='firma'></td></tr><tr><td>Кому</td><td><input type=text name='to'></td></tr><tr><td>Пожелание</td><td><input type=text name='message'></td></tr><tr><td colspan=2 align=center><input type=submit name='ok' value='Отправить'></td></tr></table></form>
	|</body>
	|</html>";
	
	СтрокаАдрес = "https://auto.yandex.ru/offers?mark=skoda&model=yeti&year_from=2013&year_to=2014&engine_type=GASOLINE&km_age_from=60000&displacement_from=1800&sort_offers=price-asc"; 
	
КонецПроцедуры
