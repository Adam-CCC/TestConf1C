
Функция CustomerTrafficGet(CustomerTrafficGetRequest)
	// Вставить содержимое обработчика.
	CustomerTrafficGetType = ФабрикаXDTO.Тип("http://wa.dms.webservice/CustomerTrafficGetRequest", "CustomerTrafficGetResponse");
	CustomerTrafficGet = ФабрикаXDTO.Создать(CustomerTrafficGetType);   
	
    ТаблицаОщибок = Новый ТаблицаЗначений;
    ТаблицаОщибок.Колонки.Добавить("Код",	 Новый ОписаниеТипов("Строка"));
    ТаблицаОщибок.Колонки.Добавить("ТекстОшибки",		 Новый ОписаниеТипов("Строка"));  
	
	Попытка
		КодДилера = CustomerTrafficGetRequest.TransactionHeader.DealerID;
	Исключение
    	НоваяСтрока = ТаблицаОщибок.Добавить();
		НоваяСтрока.Код = "WA03";
		НоваяСтрока.ТекстОшибки = "Передано неверное значение RC-кода дилера";
		CustomerTrafficGet = ПолучитьВозвратWAError("http://wa.dms.webservice/CustomerTrafficGetRequest",CustomerTrafficGetRequest,CustomerTrafficGet,"-1",ТаблицаОщибок);
		Возврат CustomerTrafficGet;    
	КонецПопытки;
	Если обЗначениеНеЗаполнено(КодДилера) Тогда
    	НоваяСтрока = ТаблицаОщибок.Добавить();
		НоваяСтрока.Код = "WA03";
		НоваяСтрока.ТекстОшибки = "Передано пустое значение RC-кода дилера";
		CustomerTrafficGet = ПолучитьВозвратWAError("http://wa.dms.webservice/CustomerTrafficGetRequest",CustomerTrafficGetRequest,CustomerTrafficGet,"-1",ТаблицаОщибок);
		Возврат CustomerTrafficGet;    
	КонецЕсли;
	ГруппаПодразделений = Справочники.ПодразделенияКомпании.НайтиПоРеквизиту("ДилерИД", КодДилера).Родитель;
	Если обЗначениеНеЗаполнено(ГруппаПодразделений) Тогда
    	НоваяСтрока = ТаблицаОщибок.Добавить();
		НоваяСтрока.Код = "WA03";
		НоваяСтрока.ТекстОшибки = "Передано неверное значение RC-кода дилера: " + КодДилера;
		CustomerTrafficGet = ПолучитьВозвратWAError("http://wa.dms.webservice/CustomerTrafficGetRequest",CustomerTrafficGetRequest,CustomerTrafficGet,"-1",ТаблицаОщибок);
		Возврат CustomerTrafficGet;    
	КонецЕсли;
	
	Попытка
		ДатаЗапроса = CustomerTrafficGetRequest.CustomerTrafficGet.Date;
	Исключение
    	НоваяСтрока = ТаблицаОщибок.Добавить();
		НоваяСтрока.Код = "WA03";
		НоваяСтрока.ТекстОшибки = "Передано неверное значение даты формирования трафика";
		CustomerTrafficGet = ПолучитьВозвратWAError("http://wa.dms.webservice/CustomerTrafficGetRequest",CustomerTrafficGetRequest,CustomerTrafficGet,"-1",ТаблицаОщибок);
		Возврат CustomerTrafficGet;    
	КонецПопытки;
	ДатаЗапроса = НачалоДня(ДатаЗапроса);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("КодДилера", КодДилера);
	Запрос.УстановитьПараметр("ГруппаПодразделений", ГруппаПодразделений);
	Запрос.УстановитьПараметр("ДатаОтчета", ДатаЗапроса);
	Запрос.Текст = "ВЫБРАТЬ
	               |	ВЫБОР
	               |		КОГДА РегистрацияЗвонковИКонтактов.ВидКонтакта = ЗНАЧЕНИЕ(Перечисление.ВидыСобытий.ТелефонныйЗвонок)
	               |			ТОГДА 1
	               |		ИНАЧЕ 0
	               |	КОНЕЦ КАК ВходящийЗвонок,
	               |	ВЫБОР
	               |		КОГДА РегистрацияЗвонковИКонтактов.ВидКонтакта = ЗНАЧЕНИЕ(Перечисление.ВидыСобытий.ЛичнаяВстреча)
	               |			ТОГДА 1
	               |		ИНАЧЕ 0
	               |	КОНЕЦ КАК Визит,
	               |	РегистрацияЗвонковИКонтактов.ПредставлениеТелефона КАК НомерТелефона,
	               |	РегистрацияЗвонковИКонтактов.ВидКонтакта
	               |ПОМЕСТИТЬ ЗвонкиВизитыСервис
	               |ИЗ
	               |	РегистрСведений.РегистрацияЗвонковИКонтактов КАК РегистрацияЗвонковИКонтактов
	               |ГДЕ
	               |	РегистрацияЗвонковИКонтактов.Подразделение В ИЕРАРХИИ(&ГруппаПодразделений)
	               |	И РегистрацияЗвонковИКонтактов.ДатаДень = &ДатаОтчета
	               |	И РегистрацияЗвонковИКонтактов.ПредметОбращения = ЗНАЧЕНИЕ(Справочник.ПредметыОбращения.Сервис)
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	СУММА(ЗвонкиВизитыСервис.ВходящийЗвонок) КАК ВходящихЗвонков,
	               |	СУММА(ЗвонкиВизитыСервис.Визит) КАК Визитов
	               |ПОМЕСТИТЬ ЗвонкиВизитыСервисИтог
	               |ИЗ
	               |	ЗвонкиВизитыСервис КАК ЗвонкиВизитыСервис
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	СУММА(ВЫБОР
	               |			КОГДА РегистрацияЗвонковИКонтактов.ВидКонтакта = ЗНАЧЕНИЕ(Перечисление.ВидыСобытий.ТелефонныйЗвонок)
	               |				ТОГДА 1
	               |			ИНАЧЕ 0
	               |		КОНЕЦ) КАК ВходящийЗвонок,
	               |	СУММА(ВЫБОР
	               |			КОГДА РегистрацияЗвонковИКонтактов.ВидКонтакта = ЗНАЧЕНИЕ(Перечисление.ВидыСобытий.ЛичнаяВстреча)
	               |				ТОГДА 1
	               |			ИНАЧЕ 0
	               |		КОНЕЦ) КАК Визит
	               |ПОМЕСТИТЬ ЗвонкиВизитыЗапчастиИтог
	               |ИЗ
	               |	РегистрСведений.РегистрацияЗвонковИКонтактов КАК РегистрацияЗвонковИКонтактов
	               |ГДЕ
	               |	РегистрацияЗвонковИКонтактов.Подразделение В ИЕРАРХИИ(&ГруппаПодразделений)
	               |	И РегистрацияЗвонковИКонтактов.ДатаДень = &ДатаОтчета
	               |	И РегистрацияЗвонковИКонтактов.ПредметОбращения = ЗНАЧЕНИЕ(Справочник.ПредметыОбращения.Запчасти)
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ЗаявкаНаРемонт.Ссылка КАК ЗаявкаНаРемонт
	               |ПОМЕСТИТЬ ЗаявкиНаРемонт
	               |ИЗ
	               |	Документ.ЗаявкаНаРемонт КАК ЗаявкаНаРемонт
	               |ГДЕ
	               |	НАЧАЛОПЕРИОДА(ЗаявкаНаРемонт.Дата, ДЕНЬ) = &ДатаОтчета
	               |	И ЗаявкаНаРемонт.ПодразделениеКомпании.ДилерИД = &КодДилера
	               |	И ЗаявкаНаРемонт.ВидРемонта.SendWA
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЗаявкиНаРемонт.ЗаявкаНаРемонт) КАК ЗаявокНаРемонт
	               |ПОМЕСТИТЬ ЗаписейНаРемонтВсего
	               |ИЗ
	               |	ЗаявкиНаРемонт КАК ЗаявкиНаРемонт
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЗаявкиНаРемонт.ЗаявкаНаРемонт) КАК ЗаявокНаРемонт
	               |ПОМЕСТИТЬ ЗаписейНаРемонтПоЗвонкам
	               |ИЗ
	               |	ЗаявкиНаРемонт КАК ЗаявкиНаРемонт
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ЗвонкиВизитыСервис КАК ЗвонкиВизитыСервис
	               |		ПО ЗаявкиНаРемонт.ЗаявкаНаРемонт.ПредставлениеТелефона = ЗвонкиВизитыСервис.НомерТелефона
	               |ГДЕ
	               |	ЗвонкиВизитыСервис.ВидКонтакта = ЗНАЧЕНИЕ(Перечисление.ВидыСобытий.ТелефонныйЗвонок)
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ЗаписейНаРемонтВсего.ЗаявокНаРемонт КАК ЗаявокНаРемонтВсего,
	               |	ЗаписейНаРемонтПоЗвонкам.ЗаявокНаРемонт КАК ЗаявокНаРемонтПоЗвонкам,
	               |	ЗвонкиВизитыЗапчастиИтог.ВходящийЗвонок КАК ЗвонковЗапчастиВсего,
	               |	ЗвонкиВизитыЗапчастиИтог.Визит КАК ВизитовЗапчастиВсего,
	               |	ЗвонкиВизитыСервисИтог.ВходящихЗвонков КАК ЗвонковСервисВсего,
	               |	ЗвонкиВизитыСервисИтог.Визитов КАК ВизитовСервисВсего
	               |ИЗ
	               |	ЗвонкиВизитыСервисИтог КАК ЗвонкиВизитыСервисИтог,
	               |	ЗаписейНаРемонтВсего КАК ЗаписейНаРемонтВсего,
	               |	ЗаписейНаРемонтПоЗвонкам КАК ЗаписейНаРемонтПоЗвонкам,
	               |	ЗвонкиВизитыЗапчастиИтог КАК ЗвонкиВизитыЗапчастиИтог";
	
	ArrayCustomerTrafficType = ФабрикаXDTO.Тип("http://wa.dms.webservice/CustomerTrafficGetRequest", "ArrayOfCustomerTraffic");
   	ArrayCustomerTraffic = ФабрикаXDTO.Создать(ArrayCustomerTrafficType); 
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Количество()=0 Тогда                         		
		CustomerTrafficGet = ПолучитьВозвратWAError("http://wa.dms.webservice/CustomerTrafficGetRequest",CustomerTrafficGetRequest,CustomerTrafficGet,"0",ТаблицаОщибок);
		Возврат CustomerTrafficGet;  		
	Иначе    
		Пока Выборка.Следующий() Цикл
		
			CustomerTrafficType = ФабрикаXDTO.Тип("http://wa.dms.webservice/CustomerTrafficGetRequest", "CustomerTraffic");
		  	CustomerTraffic = ФабрикаXDTO.Создать(CustomerTrafficType);
			CustomerTraffic.Date = ДатаЗапроса;
			CustomerTraffic.CustomerTrafficType = "1"; // количество входящих телефонных звонков
			Если ЗначениеЗаполнено(Выборка.ЗвонковСервисВсего) Тогда
				ВходящихЗвонковСервис = Выборка.ЗвонковСервисВсего;
			Иначе
				ВходящихЗвонковСервис = 0;
			КонецЕсли;
			Если ЗначениеЗаполнено(Выборка.ЗвонковЗапчастиВсего) Тогда
				ВходящихЗвонковЗапчасти = Выборка.ЗвонковЗапчастиВсего;
			Иначе
				ВходящихЗвонковЗапчасти = 0;
			КонецЕсли;
			CustomerTraffic.Value = Строка(ВходящихЗвонковСервис + ВходящихЗвонковЗапчасти);
			ArrayCustomerTraffic.CustomerTraffic.Добавить(CustomerTraffic); 
			
			CustomerTrafficType = ФабрикаXDTO.Тип("http://wa.dms.webservice/CustomerTrafficGetRequest", "CustomerTraffic");
		  	CustomerTraffic = ФабрикаXDTO.Создать(CustomerTrafficType);
			CustomerTraffic.Date = ДатаЗапроса;
			CustomerTraffic.CustomerTrafficType = "2"; // количество исходящих телефонных звонков
			CustomerTraffic.Value = "0";
			ArrayCustomerTraffic.CustomerTraffic.Добавить(CustomerTraffic); 
			
			CustomerTrafficType = ФабрикаXDTO.Тип("http://wa.dms.webservice/CustomerTrafficGetRequest", "CustomerTraffic");
		  	CustomerTraffic = ФабрикаXDTO.Создать(CustomerTrafficType);
			CustomerTraffic.Date = ДатаЗапроса;
			CustomerTraffic.CustomerTrafficType = "3"; // количество записей на ремонт по входящим телефонных звонков (по всем видам ремонта)
			Если ЗначениеЗаполнено(Выборка.ЗаявокНаРемонтПоЗвонкам) Тогда
				ЗаявокНаРемонтПоЗвонкам = Выборка.ЗаявокНаРемонтПоЗвонкам;
			Иначе
				ЗаявокНаРемонтПоЗвонкам = 0;
			КонецЕсли;
			CustomerTraffic.Value = Строка(ЗаявокНаРемонтПоЗвонкам);
			ArrayCustomerTraffic.CustomerTraffic.Добавить(CustomerTraffic);
			
			CustomerTrafficType = ФабрикаXDTO.Тип("http://wa.dms.webservice/CustomerTrafficGetRequest", "CustomerTraffic");
		  	CustomerTraffic = ФабрикаXDTO.Создать(CustomerTrafficType);
			CustomerTraffic.Date = ДатаЗапроса;
			CustomerTraffic.CustomerTrafficType = "4"; // общее количество записей на ремонт (по всем видам ремонта)
			Если ЗначениеЗаполнено(Выборка.ЗаявокНаРемонтВсего) Тогда
				ЗаявокНаРемонтВсего = Выборка.ЗаявокНаРемонтВсего;
			Иначе
				ЗаявокНаРемонтВсего = 0;
			КонецЕсли;
			CustomerTraffic.Value = Строка(ЗаявокНаРемонтВсего);
			ArrayCustomerTraffic.CustomerTraffic.Добавить(CustomerTraffic);  		
			
			CustomerTrafficType = ФабрикаXDTO.Тип("http://wa.dms.webservice/CustomerTrafficGetRequest", "CustomerTraffic");
		  	CustomerTraffic = ФабрикаXDTO.Создать(CustomerTrafficType);
			CustomerTraffic.Date = ДатаЗапроса;
			CustomerTraffic.CustomerTrafficType = "5";    // Количество исходящих звонков с информированием об Акциях
			CustomerTraffic.Value = "0";
			ArrayCustomerTraffic.CustomerTraffic.Добавить(CustomerTraffic); 
			
			CustomerTrafficType = ФабрикаXDTO.Тип("http://wa.dms.webservice/CustomerTrafficGetRequest", "CustomerTraffic");
		  	CustomerTraffic = ФабрикаXDTO.Создать(CustomerTrafficType);
			CustomerTraffic.Date = ДатаЗапроса;
			CustomerTraffic.CustomerTrafficType = "6";   // Количество созданных записей в сервис по информированию об Акциях
			CustomerTraffic.Value =  "0";      
			ArrayCustomerTraffic.CustomerTraffic.Добавить(CustomerTraffic); 
			
			CustomerTrafficType = ФабрикаXDTO.Тип("http://wa.dms.webservice/CustomerTrafficGetRequest", "CustomerTraffic");
		  	CustomerTraffic = ФабрикаXDTO.Создать(CustomerTrafficType);
			CustomerTraffic.Date = ДатаЗапроса;
			CustomerTraffic.CustomerTrafficType = "7";  // Количество входящих звонков в ОЗЧ за текущий день
			CustomerTraffic.Value =  Строка(ВходящихЗвонковЗапчасти);  
			ArrayCustomerTraffic.CustomerTraffic.Добавить(CustomerTraffic);
			
			CustomerTrafficType = ФабрикаXDTO.Тип("http://wa.dms.webservice/CustomerTrafficGetRequest", "CustomerTraffic");
		  	CustomerTraffic = ФабрикаXDTO.Создать(CustomerTrafficType);
			CustomerTraffic.Date = ДатаЗапроса;
			CustomerTraffic.CustomerTrafficType = "8";  // Количество визитов в ОЗЧ за текущий день
			Если ЗначениеЗаполнено(Выборка.ВизитовЗапчастиВсего) Тогда
				ВизитовЗапчастиВсего = Выборка.ВизитовЗапчастиВсего;
			Иначе
				ВизитовЗапчастиВсего = 0;
			КонецЕсли;
			CustomerTraffic.Value =  Строка(ВизитовЗапчастиВсего);  
			ArrayCustomerTraffic.CustomerTraffic.Добавить(CustomerTraffic); 			
		КонецЦикла;   
	КонецЕсли;
	
	CustomerTrafficGet.CustomerTraffics = ArrayCustomerTraffic;
	CustomerTrafficGet = ПолучитьВозвратWAError("http://wa.dms.webservice/CustomerTrafficGetRequest",CustomerTrafficGetRequest,CustomerTrafficGet,"1",ТаблицаОщибок);
	Возврат CustomerTrafficGet; 
КонецФункции
