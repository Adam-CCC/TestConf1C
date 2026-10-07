
Функция ClockInOut(ClockInOutRequest)
	// Вставить содержимое обработчика.
	ClockInOutType = ФабрикаXDTO.Тип("http://wa.dms.webservice/ClockInOutRequest", "ClockInOutResponse");
	ClockInOut = ФабрикаXDTO.Создать(ClockInOutType);
	
	ТаблицаОщибок = Новый ТаблицаЗначений;
    ТаблицаОщибок.Колонки.Добавить("Код",	 Новый ОписаниеТипов("Строка"));
    ТаблицаОщибок.Колонки.Добавить("ТекстОшибки",		 Новый ОписаниеТипов("Строка"));   
	// можно осуществить запись в табель рабочего времени
	
	ClockInOut = обПолучитьВозвратWAError("http://wa.dms.webservice/ClockInOutRequest",ClockInOutRequest,ClockInOut,"1",ТаблицаОщибок);
	Возврат ClockInOut;   
	
КонецФункции
