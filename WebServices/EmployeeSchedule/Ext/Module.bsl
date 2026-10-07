
Функция EmployeeScheduleGet(EmployeeScheduleGetRequest)
	// Вставить содержимое обработчика.
	EmployeeScheduleGetType = ФабрикаXDTO.Тип("http://wa.dms.webservice/EmployeeScheduleGetRequest", "EmployeeScheduleGetResponse");
	EmployeeScheduleGet = ФабрикаXDTO.Создать(EmployeeScheduleGetType);   
	
    ТаблицаОщибок = Новый ТаблицаЗначений;
    ТаблицаОщибок.Колонки.Добавить("Код",	 Новый ОписаниеТипов("Строка"));
    ТаблицаОщибок.Колонки.Добавить("ТекстОшибки",		 Новый ОписаниеТипов("Строка"));     	

    Попытка
    	КодСотрудника = EmployeeScheduleGetRequest.EmployeeScheduleGet.DMSEmployeeNo;
    Исключение
    	КодСотрудника = "";
    КонецПопытки;       
    Если ЗначениеЗаполнено(КодСотрудника) Тогда
    	Мастер = Справочники.Сотрудники.НайтиПоКоду(КодСотрудника);
		Если обЗначениеНеЗаполнено(Мастер) Тогда
			НоваяСтрока = ТаблицаОщибок.Добавить();
			НоваяСтрока.Код = "WA03";
			НоваяСтрока.ТекстОшибки = "Сотрудник с указанным кодом не найден";
			EmployeeScheduleGet = обПолучитьВозвратWAError("http://wa.dms.webservice/EmployeeScheduleGetRequest",EmployeeScheduleGetRequest,EmployeeScheduleGet,"-1",ТаблицаОщибок);
			Возврат EmployeeScheduleGet;      
		КонецЕсли;
	Иначе
		НоваяСтрока = ТаблицаОщибок.Добавить();
		НоваяСтрока.Код = "WA03";
		НоваяСтрока.ТекстОшибки = "Не задан код сотрудника";
		EmployeeScheduleGet = обПолучитьВозвратWAError("http://wa.dms.webservice/EmployeeScheduleGetRequest",EmployeeScheduleGetRequest,EmployeeScheduleGet,"-1",ТаблицаОщибок);
		Возврат EmployeeScheduleGet;      		
	КонецЕсли;
	
    Попытка
    	ДатаЗапроса = EmployeeScheduleGetRequest.EmployeeScheduleGet.SearchDateTimeLocal;
    Исключение
    	НоваяСтрока = ТаблицаОщибок.Добавить();
		НоваяСтрока.Код = "WA03";
		НоваяСтрока.ТекстОшибки = "Некорректная дата запроса";
		EmployeeScheduleGet = обПолучитьВозвратWAError("http://wa.dms.webservice/EmployeeScheduleGetRequest",EmployeeScheduleGetRequest,EmployeeScheduleGet,"-1",ТаблицаОщибок);
		Возврат EmployeeScheduleGet;    
    КонецПопытки;    
	
	Попытка
    	ТипЗапроса = EmployeeScheduleGetRequest.EmployeeScheduleGet.ScheduleType;
	    Если обЗначениеНеЗаполнено(ТипЗапроса) Тогда
			НоваяСтрока = ТаблицаОщибок.Добавить();
			НоваяСтрока.Код = "WA03";
			НоваяСтрока.ТекстОшибки = "Не задан тип выборки";
			EmployeeScheduleGet = обПолучитьВозвратWAError("http://wa.dms.webservice/EmployeeScheduleGetRequest",EmployeeScheduleGetRequest,EmployeeScheduleGet,"-1",ТаблицаОщибок);
			Возврат EmployeeScheduleGet;      
		КонецЕсли;
    Исключение
    	НоваяСтрока = ТаблицаОщибок.Добавить();
		НоваяСтрока.Код = "WA03";
		НоваяСтрока.ТекстОшибки = "Не задан тип выборки";
		EmployeeScheduleGet = обПолучитьВозвратWAError("http://wa.dms.webservice/EmployeeScheduleGetRequest",EmployeeScheduleGetRequest,EmployeeScheduleGet,"-1",ТаблицаОщибок);
		Возврат EmployeeScheduleGet; 
	КонецПопытки;  
    
	
	ArrayOfEmployeeScheduleType = ФабрикаXDTO.Тип("http://wa.dms.webservice/EmployeeScheduleGetRequest", "ArrayOfEmployeeSchedule");
	ArrayEmployeeSchedule = ФабрикаXDTO.Создать(ArrayOfEmployeeScheduleType); 
	EmployeeScheduleType = ФабрикаXDTO.Тип("http://wa.dms.webservice/EmployeeScheduleGetRequest", "EmployeeSchedule");
	EmployeeSchedule = ФабрикаXDTO.Создать(EmployeeScheduleType);
	
	EmployeeSchedule.DMSEmployeeNo = Мастер.Код;
	EmployeeSchedule.FullName = Мастер.Наименование;
	
	ArrayOfScheduleType = ФабрикаXDTO.Тип("http://wa.dms.webservice/EmployeeScheduleGetRequest", "ArrayOfSchedule");
	ArrayOfSchedule = ФабрикаXDTO.Создать(ArrayOfScheduleType); 
	 	
	Запрос = Новый Запрос;                
    Запрос.Параметры.Вставить("Сотрудник", Мастер);
	Запрос.Параметры.Вставить("ДатаЗапроса", НачалоДня(ДатаЗапроса));
	СписокРабот = Новый Массив();
	Если ТипЗапроса = "1" Тогда
		СписокРабот.Добавить(Справочники.Автоработы.Приемка);
	ИначеЕсли ТипЗапроса = "2" Тогда
		СписокРабот.Добавить(Справочники.Автоработы.Выдача);
	Иначе
		СписокРабот.Добавить(Справочники.Автоработы.Приемка);
		СписокРабот.Добавить(Справочники.Автоработы.Выдача);
	КонецЕсли;
	Запрос.Параметры.Вставить("СписокРабот", СписокРабот);
    Запрос.Текст = "ВЫБРАТЬ
                   |	ГрафикРаботыРесурсов.Объект КАК Ссылка,
                   |	ГрафикРаботыРесурсов.НачалоРабочегоВремени,
                   |	ГрафикРаботыРесурсов.КонецРабочегоВремени,
                   |	ВЫБОР
                   |		КОГДА АвтомобилиСрезПоследних.Значение ЕСТЬ NULL
                   |			ТОГДА ""нет_номера""
                   |		ИНАЧЕ ВЫРАЗИТЬ(АвтомобилиСрезПоследних.Значение КАК СТРОКА(10))
                   |	КОНЕЦ КАК ГосНомер,
                   |	ГрафикРаботыРесурсов.Объект.Диспетчер,
                   |	ГрафикРаботыРесурсов.Авторабота
                   |ИЗ
                   |	РегистрСведений.ГрафикРаботыРесурсов КАК ГрафикРаботыРесурсов
                   |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.Автомобили.СрезПоследних(, ВидЗначения = ЗНАЧЕНИЕ(Перечисление.ДополнительнаяИнформацияАвтомобилей.ГосНомер)) КАК АвтомобилиСрезПоследних
                   |		ПО ГрафикРаботыРесурсов.Объект.Автомобиль = АвтомобилиСрезПоследних.Автомобиль
                   |ГДЕ
                   |	ГрафикРаботыРесурсов.Объект.Диспетчер = &Сотрудник
                   |	И ГрафикРаботыРесурсов.Дата = &ДатаЗапроса
                   |	И ГрафикРаботыРесурсов.Объект ССЫЛКА Документ.ЗаявкаНаРемонт
                   |	И ГрафикРаботыРесурсов.Авторабота В(&СписокРабот)";
 	
    Выборка = Запрос.Выполнить().Выбрать();
    
	Если Выборка.Количество() = 0 Тогда
		Запрос.Текст = "ВЫБРАТЬ
		               |	ГрафикРаботКалендарный.ВидДня,
		               |	ГрафикРаботКалендарный.Продолжительность
		               |ИЗ
		               |	РегистрСведений.ГрафикРаботКалендарный КАК ГрафикРаботКалендарный
		               |ГДЕ
		               |	ГрафикРаботКалендарный.График = &ГрафикСотрудника
		               |	И ГрафикРаботКалендарный.Дата = &ДатаЗапроса";
					   
		Запрос.Параметры.Вставить("ГрафикСотрудника", Мастер.ГрафикРаботы);
		Выб = Запрос.Выполнить().Выбрать();
		Если Выб.Следующий() Тогда				
			Если Выб.ВидДня = Перечисления.ВидДня.Рабочий Тогда
				EmployeeScheduleGet = обПолучитьВозвратWAError("http://wa.dms.webservice/EmployeeScheduleGetRequest",EmployeeScheduleGetRequest,EmployeeScheduleGet,"0",ТаблицаОщибок);
				Возврат EmployeeScheduleGet; 
			Иначе
				ScheduleType = ФабрикаXDTO.Тип("http://wa.dms.webservice/EmployeeScheduleGetRequest", "Schedule");
			   	Schedule = ФабрикаXDTO.Создать(ScheduleType);
				Schedule.DMSAppointmentNo = "ВЫХОДНОЙ";
				Schedule.DMSRONo = "ВЫХОДНОЙ";
			   	Schedule.ScheduleType = "2";
			   	Schedule.LicensePlateNo = "ВЫХОДНОЙ"; 
			   	Schedule.StartDateTimeLocal = НачалоДня(ДатаЗапроса); 
			   	Schedule.EndDateTimeLocal = КонецДня(ДатаЗапроса);		   			
			   	ArrayOfSchedule.Schedule.Добавить(Schedule);   
			КонецЕсли;	
		Иначе
			EmployeeScheduleGet = обПолучитьВозвратWAError("http://wa.dms.webservice/EmployeeScheduleGetRequest",EmployeeScheduleGetRequest,EmployeeScheduleGet,"0",ТаблицаОщибок);
			Возврат EmployeeScheduleGet; 
		КонецЕсли;
		
    Иначе		
		Пока Выборка.Следующий() Цикл
	   		ScheduleType = ФабрикаXDTO.Тип("http://wa.dms.webservice/EmployeeScheduleGetRequest", "Schedule");
	   		Schedule = ФабрикаXDTO.Создать(ScheduleType);
			Schedule.DMSAppointmentNo = Выборка.Ссылка.Номер;
			Schedule.DMSRONo = "";
			Если Выборка.Авторабота = Справочники.Автоработы.Приемка Тогда
		   		Schedule.ScheduleType = "1";
			ИначеЕсли Выборка.Авторабота = Справочники.Автоработы.Выдача Тогда
		   		Schedule.ScheduleType = "2";
			Иначе
		   		Schedule.ScheduleType = "1";
			КонецЕсли;
	   		Schedule.LicensePlateNo = Выборка.ГосНомер; 
	   		Schedule.StartDateTimeLocal = НачалоДня(ДатаЗапроса) + (Выборка.НачалоРабочегоВремени - Дата('00010101')); 
	   		Schedule.EndDateTimeLocal = НачалоДня(ДатаЗапроса) + (Выборка.КонецРабочегоВремени - Дата('00010101'));	   			
	   		ArrayOfSchedule.Schedule.Добавить(Schedule);
		КонецЦикла; 						
	КонецЕсли;   
		
	//// у пилотного дилера не используется планирование выдачи. Для планировщика WA обозначим условную занятость на выдачу вечером
	//Если Выборка.Количество() > 0 И (ТипЗапроса = "0" ИЛИ ТипЗапроса = "2") Тогда 
	//	ScheduleType = ФабрикаXDTO.Тип("http://wa.dms.webservice/EmployeeScheduleGetRequest", "Schedule");
	//   	Schedule = ФабрикаXDTO.Создать(ScheduleType);
	//	Schedule.DMSAppointmentNo = "выдача";
	//	Schedule.DMSRONo = "выдача";
	//   	Schedule.ScheduleType = "2";
	//   	Schedule.LicensePlateNo = "выдача"; 
	//   	Schedule.StartDateTimeLocal = НачалоДня(ДатаЗапроса) + 68400;  
	//   	Schedule.EndDateTimeLocal = НачалоДня(ДатаЗапроса) + 75600;		
	//   	ArrayOfSchedule.Schedule.Добавить(Schedule);    
	//КонецЕсли;
	
	EmployeeSchedule.Schedules = ArrayOfSchedule;
	ArrayEmployeeSchedule.EmployeeSchedule.Добавить(EmployeeSchedule);
	
	EmployeeScheduleGet.EmployeeSchedules = ArrayEmployeeSchedule;
	EmployeeScheduleGet = обПолучитьВозвратWAError("http://wa.dms.webservice/EmployeeScheduleGetRequest",EmployeeScheduleGetRequest,EmployeeScheduleGet,"1",ТаблицаОщибок);
	Возврат EmployeeScheduleGet;   
КонецФункции
