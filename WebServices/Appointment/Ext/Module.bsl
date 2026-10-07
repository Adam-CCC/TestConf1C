                                                         
Функция AppointmentGet(AppointmentGetRequest)
	// Вставить содержимое обработчика. 	
	AppointmentGetType = ФабрикаXDTO.Тип("http://wa.dms.webservice/AppointmentGetRequest", "AppointmentGetResponse");
	AppointmentGet = ФабрикаXDTO.Создать(AppointmentGetType);   

	ТаблицаОщибок = Новый ТаблицаЗначений;
	ТаблицаОщибок.Колонки.Добавить("Код",	 Новый ОписаниеТипов("Строка"));
	ТаблицаОщибок.Колонки.Добавить("ТекстОшибки",		 Новый ОписаниеТипов("Строка"));    		
			
	Попытка
		НомерЗаявкиНаРемонт = AppointmentGetRequest.AppointmentGet.DMSAppointmentNo;
	Исключение
		НомерЗаявкиНаРемонт = "";
	КонецПопытки;

	Попытка
		IDЗаявкиНаРемонт = AppointmentGetRequest.AppointmentGet.DMSAppointmentID;
	Исключение
		IDЗаявкиНаРемонт = "";
	КонецПопытки;

   	Попытка
		НачДатаЗаявкиНаРемонт = AppointmentGetRequest.AppointmentGet.AppointmentDateTimeFromLocal;
	Исключение
		НачДатаЗаявкиНаРемонт = Дата('00010101');
	КонецПопытки;

	Попытка
		КонДатаЗаявкиНаРемонт = AppointmentGetRequest.AppointmentGet.AppointmentDateTimeToLocal;
	Исключение
		КонДатаЗаявкиНаРемонт = Дата('00010101');
	КонецПопытки;

	Попытка
		НачДатаИзмененияЗаявкиНаРемонт = AppointmentGetRequest.AppointmentGet.LastModifiedDateTimeFromUTC;
	Исключение
		НачДатаИзмененияЗаявкиНаРемонт = Дата('00010101');
	КонецПопытки;

	Попытка
		КонДатаИзмененияЗаявкиНаРемонт = AppointmentGetRequest.AppointmentGet.LastModifiedDateTimeToUTC;
	Исключение
		КонДатаИзмененияЗаявкиНаРемонт = Дата('00010101');
	КонецПопытки;

    Попытка
		КодМастера = AppointmentGetRequest.AppointmentGet.SAEmployeeID;
	Исключение
		КодМастера = "";
	КонецПопытки;

	Попытка
		НаименованиеМастера = AppointmentGetRequest.AppointmentGet.SAEmployeeName;
	Исключение
		НаименованиеМастера = "";
	КонецПопытки;

    Попытка
		КодКонтрагента = AppointmentGetRequest.AppointmentGet.CustomerGet.DMSCustomerNo;
	Исключение
		КодКонтрагента = "";
	КонецПопытки;

	Попытка
		ФамилияКонтрагента = AppointmentGetRequest.AppointmentGet.CustomerGet.LastName;
	Исключение
		ФамилияКонтрагента = "";
	КонецПопытки;
	
	Если ЗначениеЗаполнено(ФамилияКонтрагента) Тогда
		Если СтрДлина(ФамилияКонтрагента)<3 Тогда
			НоваяСтрока = ТаблицаОщибок.Добавить();
			НоваяСтрока.Код = "ROG01";
			НоваяСтрока.ТекстОшибки = "Для поиска по фамилии должно быть не менее 3 символов";
			AppointmentGet = обПолучитьВозвратWAError("http://wa.dms.webservice/AppointmentGetRequest",AppointmentGetRequest,AppointmentGet,"-1",ТаблицаОщибок);
			Возврат AppointmentGet;      
		КонецЕсли;
	КонецЕсли;

    // ОСТАВИМ МЕСТО ПОД КОНТАКТЫ
	Попытка
		МассивКонтактовКонтрагента = AppointmentGetRequest.AppointmentGet.CustomerGet.Contacts;  
		Для Каждого Контакт Из МассивКонтактовКонтрагента.Contact Цикл
		//Контакт.ContactType;
		КонецЦикла; 
	Исключение
		//МассивКонтактовКонтрагента = 
	КонецПопытки;

	Попытка
		КодАвтомобиля = AppointmentGetRequest.AppointmentGet.VehicleGet.DMSVehicleNo;
	Исключение
		КодАвтомобиля = "";
	КонецПопытки;

	Попытка
		VINАвтомобиля = AppointmentGetRequest.AppointmentGet.VehicleGet.VIN;
	Исключение
		VINАвтомобиля = "";
	КонецПопытки;
	
	Если ЗначениеЗаполнено(VINАвтомобиля) Тогда
		Если СтрДлина(VINАвтомобиля)<>17 Тогда
			НоваяСтрока = ТаблицаОщибок.Добавить();
			НоваяСтрока.Код = "AG03";
			НоваяСтрока.ТекстОшибки = "VIN должен состоять из 17 символов";
			AppointmentGet = обПолучитьВозвратWAError("http://wa.dms.webservice/AppointmentGetRequest",AppointmentGetRequest,AppointmentGet,"-1",ТаблицаОщибок);
			Возврат AppointmentGet;      
		КонецЕсли;
	КонецЕсли;

    Попытка
		ФрагментVINАвтомобиля = AppointmentGetRequest.AppointmentGet.VehicleGet.LastSixVIN;
	Исключение
		ФрагментVINАвтомобиля = "";
	КонецПопытки;
	
	Если ЗначениеЗаполнено(ФрагментVINАвтомобиля) Тогда
		Если СтрДлина(ФрагментVINАвтомобиля)<6 Тогда
			НоваяСтрока = ТаблицаОщибок.Добавить();
			НоваяСтрока.Код = "AG04";
			НоваяСтрока.ТекстОшибки = "Фрагмент VIN для поиска должен быть не менее 6 символов";
			AppointmentGet = обПолучитьВозвратWAError("http://wa.dms.webservice/AppointmentGetRequest",AppointmentGetRequest,AppointmentGet,"-1",ТаблицаОщибок);
			Возврат AppointmentGet;      
		КонецЕсли;
    КонецЕсли;
	
    Запрос = Новый Запрос;
	
	// БЛОК КЛЮЧЕВОГО ПОИСКА
	СтрокаКлючевогоПоиска = "";	
	Если ЗначениеЗаполнено(IDЗаявкиНаРемонт) Тогда
		ID = Новый УникальныйИдентификатор(IDЗаявкиНаРемонт);
		ЗаявкаСсылка = Документы.ЗаявкаНаРемонт.ПолучитьСсылку(ID);
		Если ЗаявкаСсылка.ПолучитьОбъект() = Неопределено Тогда
			НоваяСтрока = ТаблицаОщибок.Добавить();
			НоваяСтрока.Код = "WA03";
			НоваяСтрока.ТекстОшибки = "Заявка на ремонт с указанным идентификатором не найдена";
			AppointmentGet = обПолучитьВозвратWAError("http://wa.dms.webservice/AppointmentGetRequest",AppointmentGetRequest,AppointmentGet,"-1",ТаблицаОщибок);
			Возврат AppointmentGet;   
		КонецЕсли;
	Иначе
		ЗаявкаСсылка = Документы.ЗаявкаНаРемонт.ПустаяСсылка();
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ЗаявкаСсылка) Тогда
		СтрокаКлючевогоПоиска = "ЗаявкаНаРемонт.Ссылка = &ЗаявкаНаРемонт";
		Запрос.Параметры.Вставить("ЗаявкаНаРемонт", ЗаявкаСсылка);
	ИначеЕсли ЗначениеЗаполнено(НомерЗаявкиНаРемонт) Тогда
		СтрокаКлючевогоПоиска = "ЗаявкаНаРемонт.Номер = &НомерЗаявкиНаРемонт";
		Запрос.Параметры.Вставить("НомерЗаявкиНаРемонт", НомерЗаявкиНаРемонт);
	Иначе
		НоваяСтрока = ТаблицаОщибок.Добавить();
		НоваяСтрока.Код = "WA03";
		НоваяСтрока.ТекстОшибки = "Не задано ни одного ключевого параметра для поиска!";
		AppointmentGet = обПолучитьВозвратWAError("http://wa.dms.webservice/AppointmentGetRequest",AppointmentGetRequest,AppointmentGet,"-1",ТаблицаОщибок);
		Возврат AppointmentGet;   
	КонецЕсли;   
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	ЗаявкаНаРемонт.Ссылка,
	               |	ЗаявкаНаРемонт.Номер,
	               |	ЗаявкаНаРемонт.Дата КАК Дата,
	               |	ЗаявкаНаРемонт.ДокументОснование,
	               |	ЗаявкаНаРемонт.ВидРемонта,
	               |	ЗаявкаНаРемонт.Заказчик,
	               |	ЗаявкаНаРемонт.КонтактнаяИнформация,
	               |	ЗаявкаНаРемонт.Автомобиль,
	               |	ЗаявкаНаРемонт.Контрагент,
	               |	ЗаявкаНаРемонт.Диспетчер,
	               |	ЗаявкаНаРемонт.ДатаНачала,
	               |	ЗаявкаНаРемонт.ДатаОкончания,
	               |	ЗаявкаНаРемонт.ПричинаОбращения,
	               |	ЗаявкаНаРемонт.Цех,
	               |	ЗаявкаНаРемонт.ВидОплаты
	               |ИЗ
	               |	Документ.ЗаявкаНаРемонт КАК ЗаявкаНаРемонт
	               |ГДЕ
				   //|	ВЫБОР
				   //|		КОГДА ТИПЗНАЧЕНИЯ(ЗаявкаНаРемонт.Автомобиль) = ТИП(Справочник.Автомобили)
				   //|			ТОГДА ЗаявкаНаРемонт.Автомобиль.Модель.Марка = &Hyundai
				   //|		ИНАЧЕ ЗаявкаНаРемонт.Автомобиль.Марка = &Hyundai
				   //|	КОНЕЦ
				   |	" + СтрокаКлючевогоПоиска + "   
	               //|	И ЗаявкаНаРемонт.ДатаНачала МЕЖДУ &ДатаНач И &ДатаКон
	               |	"+?(ЗначениеЗаполнено(КодМастера),"И ЗаявкаНаРемонт.Диспетчер.Код = &КодМастера","")+"
	               |	"+?(ЗначениеЗаполнено(НаименованиеМастера),"И ЗаявкаНаРемонт.Диспетчер.Наименование = &НаименованиеМастера","")+"
                   |	"+?(ЗначениеЗаполнено(КодКонтрагента),"И ВЫБОР
	               |			КОГДА ТИПЗНАЧЕНИЯ(ЗаявкаНаРемонт.Заказчик) = ТИП(Справочник.Контрагенты)
	               |				ТОГДА ЗаявкаНаРемонт.Заказчик.Код = &КодЗаказчика
	               |			ИНАЧЕ ЗаявкаНаРемонт.Заказчик = &КодЗаказчика
	               |		КОНЕЦ","")+"
                   |	"+?(ЗначениеЗаполнено(ФамилияКонтрагента),"И ВЫБОР
	               |			КОГДА ТИПЗНАЧЕНИЯ(ЗаявкаНаРемонт.Заказчик) = ТИП(Справочник.Контрагенты)
	               |				ТОГДА ЗаявкаНаРемонт.Заказчик.Наименование ПОДОБНО &ФамилияКонтрагента
	               |			ИНАЧЕ ЗаявкаНаРемонт.Заказчик ПОДОБНО &ФамилияКонтрагента
	               |		КОНЕЦ","")+"
                   |	"+?(ЗначениеЗаполнено(КодАвтомобиля),"И ЗаявкаНаРемонт.Автомобиль.Код = &КодАвтомобиля","")+"
                   |	"+?(ЗначениеЗаполнено(VINАвтомобиля),"И ВЫБОР
	               |			КОГДА ТИПЗНАЧЕНИЯ(ЗаявкаНаРемонт.Автомобиль) = ТИП(Справочник.Автомобили)
	               |				ТОГДА ЗаявкаНаРемонт.Автомобиль.VIN = &VIN
	               |			ИНАЧЕ ЗаявкаНаРемонт.Автомобиль.Код = &НевозможныйПоиск
	               |		КОНЕЦ","")+"
                   |	"+?(ЗначениеЗаполнено(ФрагментVINАвтомобиля),"И ВЫБОР
	               |			КОГДА ТИПЗНАЧЕНИЯ(ЗаявкаНаРемонт.Автомобиль) = ТИП(Справочник.Автомобили)
	               |				ТОГДА ЗаявкаНаРемонт.Автомобиль.VIN ПОДОБНО &ФрагментVINАвтомобиля
	               |			ИНАЧЕ ЗаявкаНаРемонт.Автомобиль.Наименование = &НевозможныйПоиск
	               |		КОНЕЦ","")+"
	               |	
				   |УПОРЯДОЧИТЬ ПО
	               |	Дата УБЫВ";
				   
	//Запрос.Параметры.Вставить("Hyundai", Справочники.Марка.HYUNDAI);			   
	//Если обЗначениеНеЗаполнено(НачДатаЗаявкиНаРемонт) Тогда
	//	Запрос.Параметры.Вставить("ДатаНач",ДобавитьМесяц(ТекущаяДата(),-6));
	//Иначе
	//	Запрос.Параметры.Вставить("ДатаНач",НачДатаЗаявкиНаРемонт);
	//КонецЕсли;   		
	//Если обЗначениеНеЗаполнено(КонДатаЗаявкиНаРемонт) Тогда
	//	Запрос.Параметры.Вставить("ДатаКон",Дата('20300101'));
	//Иначе
	//	Запрос.Параметры.Вставить("ДатаКон",КонДатаЗаявкиНаРемонт);
	//КонецЕсли;   
	
	Если ЗначениеЗаполнено(КодМастера) Тогда
		Запрос.Параметры.Вставить("КодМастера",КодМастера);
	КонецЕсли;   
    Если ЗначениеЗаполнено(НаименованиеМастера) Тогда
		Запрос.Параметры.Вставить("НаименованиеМастера",НаименованиеМастера);
	КонецЕсли;
	Если ЗначениеЗаполнено(КодКонтрагента) Тогда
		Запрос.Параметры.Вставить("КодЗаказчика",КодКонтрагента);
	КонецЕсли;
    Если ЗначениеЗаполнено(ФамилияКонтрагента) Тогда
		Запрос.Параметры.Вставить("ФамилияКонтрагента","%"+ФамилияКонтрагента+"%");
	КонецЕсли;
    Если ЗначениеЗаполнено(КодАвтомобиля) Тогда
		Запрос.Параметры.Вставить("КодАвтомобиля",КодАвтомобиля);
	КонецЕсли;
    Если ЗначениеЗаполнено(VINАвтомобиля) Тогда
		Запрос.Параметры.Вставить("VIN",VINАвтомобиля);
		Запрос.Параметры.Вставить("НевозможныйПоиск","");
	КонецЕсли;
    Если ЗначениеЗаполнено(ФрагментVINАвтомобиля) Тогда
		Запрос.Параметры.Вставить("ФрагментVINАвтомобиля","%"+ФрагментVINАвтомобиля+"%");
		Запрос.Параметры.Вставить("НевозможныйПоиск","");
	КонецЕсли;     
	
	
	Выборка = Запрос.Выполнить().Выбрать();

    Если Выборка.Количество()=0 Тогда                         		
		AppointmentGet = обПолучитьВозвратWAError("http://wa.dms.webservice/AppointmentGetRequest",AppointmentGetRequest,AppointmentGet,"0",ТаблицаОщибок);
		Возврат AppointmentGet;
	Иначе 		
		AppointmentsType = ФабрикаXDTO.Тип("http://wa.dms.webservice/AppointmentGetRequest", "ArrayOfAppointment");
		Appointments = ФабрикаXDTO.Создать(AppointmentsType); 	
	
		AppointmentType = ФабрикаXDTO.Тип("http://wa.dms.webservice/AppointmentGetRequest", "Appointment");     		
		Пока Выборка.Следующий() Цикл 	
			Если ЗначениеЗаполнено(ФамилияКонтрагента) Тогда
				Если ТипЗнч(Выборка.Заказчик)=Тип("СправочникСсылка.Контрагенты") Тогда   
					Фамилия = обПолучитьФамилия(Выборка.Заказчик.Наименование);
				Иначе
				    Фамилия = Выборка.Заказчик;
				КонецЕсли;
				Если нрег(Фамилия)<>нрег(ФамилияКонтрагента) Тогда
					продолжить;
				КонецЕсли;
			КонецЕсли;
			
			Appointment = ФабрикаXDTO.Создать(AppointmentType); 
	        Appointment.DMSAppointmentNo = Выборка.Номер;
			Appointment.DMSAppointmentID = Строка(Выборка.Ссылка.УникальныйИдентификатор());
			Если Выборка.Ссылка.ХозОперация = Справочники.ХозОперации.ПланРемонта И Выборка.Ссылка.Планирование.Количество() > 0 Тогда
				ПланированиеПерваяСтрока = Выборка.Ссылка.Планирование[0];
				ПланированиеПоследняяСтрока = Выборка.Ссылка.Планирование[Выборка.Ссылка.Планирование.Количество()-1];
	            Appointment.AppointmentDateTimeLocal = ПланированиеПерваяСтрока.НачалоВыполнения;   
				Appointment.DeliveryDateTimeLocal = ПланированиеПоследняяСтрока.ОкончаниеВыполнения;
			Иначе
	            Appointment.AppointmentDateTimeLocal = Выборка.ДатаНачала;   
				Appointment.DeliveryDateTimeLocal = Выборка.ДатаОкончания;
			КонецЕсли;
			Appointment.OpenDateTimeLocal = Выборка.Дата;
            Appointment.CloseDateTimeLocal = Дата('00010101'); 
			Appointment.DMSAppointmentStatus = "1";
			Если Выборка.Цех = Справочники.Цеха.ОсновнойЦех Тогда
				Appointment.WorkType = "2";          	
			Иначе
				Appointment.WorkType = "1";    
			КонецЕсли;   			
			Appointment.ServiceType	= Выборка.ВидРемонта.КраткоеОбозначение;         			
			Если Выборка.ВидОплаты = Перечисления.ВидыОплаты.НаличныйРасчет Тогда
				Appointment.PaymentMethod = "1";
			ИначеЕсли Выборка.ВидОплаты = Перечисления.ВидыОплаты.БанковскаяКарта Тогда
            	Appointment.PaymentMethod = "3";
            ИначеЕсли Выборка.ВидОплаты = Перечисления.ВидыОплаты.БезналичныйРасчет Тогда
            	Appointment.PaymentMethod = "2";
			Иначе
				Appointment.PaymentMethod = "1";
			КонецЕсли; 			
			Если ТипЗнч(Выборка.Автомобиль) = Тип("СправочникСсылка.Автомобили") Тогда
				Пробег = Справочники.Автомобили.ЧтениеЗначенияРегистраСведения(Выборка.Автомобиль, 
									Перечисления.ДополнительнаяИнформацияАвтомобилей.Пробег, Выборка.ДатаНачала);				
				Если обЗначениеНеЗаполнено(Пробег) Тогда
					Appointment.InMileage	= ""; 
				Иначе
					Appointment.InMileage	= Формат(Пробег, "ЧЦ=15; ЧДЦ=2; ЧРД=.; ЧГ=0");
				КонецЕсли; 
			Иначе
				Appointment.InMileage	= ""; 	
			КонецЕсли; 			
			Appointment.SAEmployeeID = Выборка.Диспетчер.Код;
			Appointment.SAEmployeeName = Выборка.Диспетчер.Наименование;  
            Appointment.TCEmployeeID = "";
			Appointment.TCEmployeeName = "";
			Appointment.CustomerComment = Выборка.ПричинаОбращения;
			Appointment.AppointmentChannel = "1";
			
			//ПерваяЗапись = РегистрыСведений.Версионирование.ПолучитьПервое(,Новый Структура("Идентификатор, ПредставлениеМетаданных",Выборка.Ссылка.УникальныйИдентификатор(),Выборка.Ссылка.Метаданные().ПолноеИмя()));
			//ПоследняяЗапись = РегистрыСведений.Версионирование.ПолучитьПоследнее(,Новый Структура("Идентификатор, ПредставлениеМетаданных",Выборка.Ссылка.УникальныйИдентификатор(),Выборка.Ссылка.Метаданные().ПолноеИмя()));
			ManagementFieldsDataType = ФабрикаXDTO.Тип("http://wa.dms.webservice/AppointmentGetRequest", "ManagementFields");
			ManagementFieldsData = ФабрикаXDTO.Создать(ManagementFieldsDataType); 
			ПерваяЗапись = ТекущаяДата();
			ПоследняяЗапись = ТекущаяДата();
			ManagementFieldsData.CreateDateTimeUTC = ПерваяЗапись;
			ManagementFieldsData.LastModifiedDateTimeUTC = ПоследняяЗапись;
			Appointment.ManagementFields = ManagementFieldsData;
			
			JobRefsType = ФабрикаXDTO.Тип("http://wa.dms.webservice/AppointmentGetRequest", "ArrayOfJobRef");
			JobRefs = ФабрикаXDTO.Создать(JobRefsType); 
            Appointment.JobRefs = JobRefs;
			
			RORefsType = ФабрикаXDTO.Тип("http://wa.dms.webservice/AppointmentGetRequest", "ArrayOfRORef");
			RORefs = ФабрикаXDTO.Создать(RORefsType); 
			
			МассивВидов=Новый Массив(1); МассивВидов[0]="ЗаказНаряд"; 
			МассивПодчиненныхДокументов = дкПолучитьМассивПодчиненных(Выборка.Ссылка, МассивВидов);  
			Если МассивПодчиненныхДокументов.Количество() > 0 Тогда
				Для Каждого СтрДокумент Из МассивПодчиненныхДокументов Цикл
					RORefType = ФабрикаXDTO.Тип("http://wa.dms.webservice/AppointmentGetRequest", "RORef");
					RORef = ФабрикаXDTO.Создать(RORefType); 
					RORef.DMSRONo = СтрДокумент.Номер;
					RORef.DMSROID = Строка(СтрДокумент.УникальныйИдентификатор());
					Если СтрДокумент.Состояние = Справочники.ВидыСостоянийЗаказНарядов.Заявка Тогда
						Состояние =  "1";	
					ИначеЕсли СтрДокумент.Состояние = Справочники.ВидыСостоянийЗаказНарядов.ВРаботе Тогда
						Состояние = "2";
					ИначеЕсли СтрДокумент.Состояние = Справочники.ВидыСостоянийЗаказНарядов.Согласование Тогда
						Состояние = "3";
					ИначеЕсли СтрДокумент.Состояние = Справочники.ВидыСостоянийЗаказНарядов.Ожидание Тогда
						Состояние = "4";
					ИначеЕсли СтрДокумент.Состояние = Справочники.ВидыСостоянийЗаказНарядов.Стоянка Тогда
						Состояние = "5";
					ИначеЕсли СтрДокумент.Состояние = Справочники.ВидыСостоянийЗаказНарядов.Выполнен Тогда
						Состояние = "6";
					ИначеЕсли СтрДокумент.Состояние = Справочники.ВидыСостоянийЗаказНарядов.Закрыт Тогда
						Состояние = "7";
					ИначеЕсли СтрДокумент.Состояние = Справочники.ВидыСостоянийЗаказНарядов.ВРезерве Тогда
						Состояние = "8";
					ИначеЕсли СтрДокумент.Состояние = Справочники.ВидыСостоянийЗаказНарядов.Отказ Тогда
						Состояние = "9";
			        КонецЕсли;     
					RORef.DMSROStatus = Состояние;
					
					RORefs.RORef.Добавить(RORef);
				КонецЦикла;	
			КонецЕсли;                                 			
            Appointment.RORefs = RORefs;

            AdditionalFieldsType = ФабрикаXDTO.Тип("http://wa.dms.webservice/AppointmentGetRequest", "ArrayOfAdditionalField");
			AdditionalFields = ФабрикаXDTO.Создать(AdditionalFieldsType); 
			Appointment.AdditionalFields = AdditionalFields;
			
			OptionsType = ФабрикаXDTO.Тип("http://wa.dms.webservice/AppointmentGetRequest", "ArrayOfOption");
			Options = ФабрикаXDTO.Создать(OptionsType); 
			Если ТипЗнч(Выборка.Заказчик)=Тип("СправочникСсылка.Контрагенты") Тогда
				OptionType = ФабрикаXDTO.Тип("http://wa.dms.webservice/AppointmentGetRequest", "Option");
				Option = ФабрикаXDTO.Создать(OptionType); 
				Option.OptionName = "PersonalInfoAgreeYN";
				СогласенДо = Выборка.Заказчик._г_ДатаОкончанияСогласия; 
				Option.OptionValue = ?(Выборка.Заказчик.СогласиеНаОбработкуПерсональныхДанных=Перечисления.ВариантыОтветов.Да И СогласенДо>ТекущаяДата(),"Y","N");			
				Options.Option.Добавить(Option);
			КонецЕсли;
					
			OptionType = ФабрикаXDTO.Тип("http://wa.dms.webservice/AppointmentGetRequest", "Option");
			Option = ФабрикаXDTO.Создать(OptionType); 
			Option.OptionName = "CustomerCheckedInYN";
			Option.OptionValue = ?(МассивПодчиненныхДокументов.Количество()>0,"Y","N");
			Options.Option.Добавить(Option);        			
			Appointment.Options = Options;

            PriceType = ФабрикаXDTO.Тип("http://wa.dms.webservice/AppointmentGetRequest", "PriceType");
			Price = ФабрикаXDTO.Создать(PriceType); 
			Price.UnitPrice = Формат(Выборка.Ссылка.Товары.Итог("Сумма")+Выборка.Ссылка.Работы.Итог("Сумма"),"ЧЦ=15; ЧДЦ=2; ЧРД=.; ЧГ=0");
			Price.TotalPrice = Формат(Выборка.Ссылка.Товары.Итог("СуммаВсего")+Выборка.Ссылка.Работы.Итог("СуммаВсего"),"ЧЦ=15; ЧДЦ=2; ЧРД=.; ЧГ=0");
			Price.TotalPriceIncludeTax = Формат(Выборка.Ссылка.Товары.Итог("СуммаВсего")+Выборка.Ссылка.Работы.Итог("СуммаВсего"),"ЧЦ=15; ЧДЦ=2; ЧРД=.; ЧГ=0");
			Price.DiscountRate = "0";
			Price.DiscountPrice = Формат(Выборка.Ссылка.СуммаСкидкиНаценки+Выборка.Ссылка.СуммаСкидкиНаценкиРабот,"ЧЦ=15; ЧДЦ=2; ЧРД=.; ЧГ=0");
			Appointment.PriceType = Price;

   			CustomersType = ФабрикаXDTO.Тип("http://wa.dms.webservice/AppointmentGetRequest", "ArrayOfCustomer");
			Customers = ФабрикаXDTO.Создать(CustomersType);
			
			// ЗАКАЗЧИК 	
			CustomerType = ФабрикаXDTO.Тип("http://wa.dms.webservice/AppointmentGetRequest", "Customer");
			CustomerData = ФабрикаXDTO.Создать(CustomerType); 
			Если ТипЗнч(Выборка.Заказчик)=Тип("СправочникСсылка.Контрагенты") Тогда                         			
				CustomerData = обGetCustomer("http://wa.dms.webservice/AppointmentGetRequest", CustomerData, Выборка.Заказчик, "2");		        
			Иначе    			
				CustomerData.CustomerInfoType = "2";
				CustomerData.DMSCustomerNo = "";
				CustomerData.LastName = "";
				CustomerData.MiddleName = "";
				CustomerData.FirstName = "";
				CustomerData.FullName = Выборка.Заказчик;
				CustomerData.Salutation = "";
				CustomerData.Gender = "";
				CustomerData.CardNo = "";
				CustomerData.Email = ""; 						
				CustomerAdressesType = ФабрикаXDTO.Тип("http://wa.dms.webservice/AppointmentGetRequest", "ArrayOfAddress");
				CustomerAdresses = ФабрикаXDTO.Создать(CustomerAdressesType);
                CustomerData.Addresses = CustomerAdresses;		    						
				CustomerContactsType = ФабрикаXDTO.Тип("http://wa.dms.webservice/AppointmentGetRequest", "ArrayOfContact");
				CustomerContacts = ФабрикаXDTO.Создать(CustomerContactsType); 				
				Если ЗначениеЗаполнено(Выборка.КонтактнаяИнформация) Тогда
	         		ContactType = ФабрикаXDTO.Тип("http://wa.dms.webservice/AppointmentGetRequest", "Contact");
					ContactData = ФабрикаXDTO.Создать(ContactType);
					ContactData.ContactType = "CP";
					ContactData.ContactValue = Выборка.КонтактнаяИнформация;
					ContactData.ContactMethodYN = "";
					CustomerContacts.Contact.Добавить(ContactData);
				КонецЕсли;
			    CustomerData.Contacts = CustomerContacts;							
				SpecialMessageType = ФабрикаXDTO.Тип("http://wa.dms.webservice/AppointmentGetRequest", "SpecialMessage");
				SpecialMessage = ФабрикаXDTO.Создать(SpecialMessageType);
			    CustomerData.SpecialMessage = SpecialMessage;      				
				CorporateInfosType = ФабрикаXDTO.Тип("http://wa.dms.webservice/AppointmentGetRequest", "ArrayOfCorporateInfo");
				CorporateInfos = ФабрикаXDTO.Создать(CorporateInfosType);   			
				CustomerData.CorporateInfos = CorporateInfos;  				
			КонецЕсли;
			Customers.Customer.Добавить(CustomerData);
			
			// ВЛАДЕЛЕЦ 	
			//Если НЕ Выборка.Контрагент=Справочники.Контрагенты.ПустаяСсылка() Тогда
			//	CustomerType = ФабрикаXDTO.Тип("http://wa.dms.webservice/AppointmentGetRequest", "Customer");
			//	CustomerData = ФабрикаXDTO.Создать(CustomerType);                     			
			//	CustomerData = обGetCustomer("http://wa.dms.webservice/AppointmentGetRequest", CustomerData, Выборка.Контрагент, "1");
			//	Customers.Customer.Добавить(CustomerData);
			//КонецЕсли; 				
			Appointment.Customers = Customers;
			
			// АВТОМОБИЛЬ
			VehicleType = ФабрикаXDTO.Тип("http://wa.dms.webservice/AppointmentGetRequest", "Vehicle");
			VehicleData = ФабрикаXDTO.Создать(VehicleType);
			Если ТипЗнч(Выборка.Автомобиль) = Тип("СправочникСсылка.Автомобили") Тогда
				VehicleData = обGetVehicle("http://wa.dms.webservice/AppointmentGetRequest", VehicleData, Выборка.Автомобиль);		        
			ИначеЕсли ТипЗнч(Выборка.Автомобиль) = Тип("СправочникСсылка.Модели") Тогда    		
				VehicleData.DMSVehicleNo = "";
				VehicleData.VIN = "";
				VehicleData.StockNumber = ""; 
				VehicleData.LicensePlateNo = Выборка.Ссылка.ГосНомер; 	
				VehicleData.Make = ""; 
				VehicleData.ModelCode = Выборка.Автомобиль.Код; 
				VehicleData.ModelName = Выборка.Автомобиль.Наименование; 
				VehicleData.ModelYear = "";                				
				VehicleData.LastMileage = ""; 
				VehicleData.Color = "";
				VehicleData.VehicleType = Выборка.Автомобиль.НаименованиеWA; 
			    VehicleData.EngineType = ""; 
				VehicleData.FuelType = ""; 
				VehicleData.Cylinders = ""; 
			    VehicleData.Trim = ""; 
				VehicleData.FullModelName = Выборка.Автомобиль.Наименование;
				VehicleData.InsuranceDate = Дата('00010101'); 
			    VehicleData.DateInService = Дата('00010101'); 
				VehicleData.DateDelivered = Дата('00010101');
				VehicleData.WarrantyStartDate = Дата('00010101');  
			    VehicleData.WarrantyMonths = ""; 
				VehicleData.WarrantyMiles = ""; 
				VehicleData.LicenseNumber = ""; 
				VehicleData.LastServiceDate = Дата('00010101');	 
			    VehicleData.ExtendedWarranty = Дата('00010101'); 
				VehicleData.DeclinedJob = "";
				VehicleData.PendingJob = ""; 
			    VehicleData.DisplayDescription = Выборка.Автомобиль.Наименование + " " + Выборка.Ссылка.ГосНомер; 
				CampaignsType = ФабрикаXDTO.Тип("http://wa.dms.webservice/AppointmentGetRequest", "ArrayOfCampaign");
				Campaigns = ФабрикаXDTO.Создать(CampaignsType);       			
				VehicleData.Campaigns = Campaigns;
				VehicleData.ExtendedWarrantyExpireDate = Дата('00010101');
			    VehicleData.EngineNo = ""; 
			Иначе
				VehicleData.DMSVehicleNo = "";
				VehicleData.VIN = "";
				VehicleData.StockNumber = ""; 
				VehicleData.LicensePlateNo = Выборка.Ссылка.ГосНомер; 	
				VehicleData.Make = ""; 
				VehicleData.ModelName = Выборка.Автомобиль;
			    VehicleData.DisplayDescription = Выборка.Автомобиль + " " + Выборка.Ссылка.ГосНомер; 
				CampaignsType = ФабрикаXDTO.Тип("http://wa.dms.webservice/AppointmentGetRequest", "ArrayOfCampaign");
				Campaigns = ФабрикаXDTO.Создать(CampaignsType);       			
				VehicleData.Campaigns = Campaigns;
				VehicleData.ExtendedWarrantyExpireDate = Дата('00010101');
			    VehicleData.EngineNo = ""; 
			КонецЕсли;
			Appointment.Vehicle = VehicleData;

            RequestItemsType = ФабрикаXDTO.Тип("http://wa.dms.webservice/AppointmentGetRequest", "ArrayOfRequestItem");
			RequestItems = ФабрикаXDTO.Создать(RequestItemsType); 

			// РАБОТЫ
			RequestItemType = ФабрикаXDTO.Тип("http://wa.dms.webservice/AppointmentGetRequest", "RequestItem");
			RequestItemJobs = ФабрикаXDTO.Создать(RequestItemType); 
            RequestItemJobs.ServiceLineNumber = "1";
			RequestItemJobs.ServiceLineStatus = "";
			RequestItemJobs.RequestCode = "Request_OP";
			RequestItemJobs.RequestDescription = "";
			RequestItemJobs.CPSIND = "";
			RequestItemJobs.WorkType = "1";    
			RequestItemJobs.ServiceType	= Выборка.ВидРемонта.КраткоеОбозначение;
            RequestItemJobs.TCEmployeeID = "";
			RequestItemJobs.TCEmployeeName = "";   
			CommentsType = ФабрикаXDTO.Тип("http://wa.dms.webservice/AppointmentGetRequest", "ArrayOfComment");
			Comments = ФабрикаXDTO.Создать(CommentsType);
			RequestItemJobs.Comments = Comments;  			
			DescriptionsType = ФабрикаXDTO.Тип("http://wa.dms.webservice/AppointmentGetRequest", "ArrayOfDescription");
			Descriptions = ФабрикаXDTO.Создать(DescriptionsType);
			RequestItemJobs.Descriptions = Descriptions;
			
			OPCodesType = ФабрикаXDTO.Тип("http://wa.dms.webservice/AppointmentGetRequest", "ArrayOfOPCode");
			OPCodes = ФабрикаXDTO.Создать(OPCodesType);
			КраткоеОбозначение = Выборка.ВидРемонта.КраткоеОбозначение;
			Если ТипЗнч(Выборка.Автомобиль) = Тип("СправочникСсылка.Автомобили") И КраткоеОбозначение = "10" Тогда
				КодПакетаТО = ПолучитьКодПакетаТО(Выборка.Автомобиль, Appointment.CustomerComment);
			Иначе
				КодПакетаТО = "";
			КонецЕсли;
			Для Каждого Работа Из Выборка.Ссылка.Работы Цикл
				OPCodeType = ФабрикаXDTO.Тип("http://wa.dms.webservice/AppointmentGetRequest", "OPCode");
				OPCode = ФабрикаXDTO.Создать(OPCodeType); 
	            OPCode.SequenceNumber = Выборка.Ссылка.Работы.Индекс(Работа);
				Если обЗначениеНеЗаполнено(Работа.Работа.Артикул) Тогда
					OPCode.Code = Работа.Работа.Код;
					OPCode.OPCodeType = "2";
				Иначе
					OPCode.Code = Работа.Работа.Код;
					OPCode.OPCodeType = "1";
				КонецЕсли;  				
				OPCode.Description = Работа.Работа.Наименование;
				OPCode.PackageCode = КодПакетаТО;
				OPCode.DisplayOPCode = OPCode.Code;
				OPCode.AdditionalType = "0";
				OPCode.EstimatedHours = Формат(Работа.Коэффициент,"ЧЦ=15; ЧДЦ=2; ЧРД=.; ЧГ=0");   
				OPCode.ActualHours = "";
				OPCode.SkillLevel = "";
				OPCode.ServiceType = КраткоеОбозначение;
                OPCode.Quantity = Формат(Работа.Количество,"ЧЦ=15; ЧДЦ=2; ЧРД=.; ЧГ=0");
				
				PriceType = ФабрикаXDTO.Тип("http://wa.dms.webservice/AppointmentGetRequest", "PriceType");
				Price = ФабрикаXDTO.Создать(PriceType); 
				Price.UnitPrice = Формат(Работа.Цена*Работа.Коэффициент,"ЧЦ=15; ЧДЦ=2; ЧРД=.; ЧГ=0");
				Price.TotalPrice = Формат(Работа.СуммаВсего,"ЧЦ=15; ЧДЦ=2; ЧРД=.; ЧГ=0");
				Price.TotalPriceIncludeTax = Формат(Работа.СуммаВсего,"ЧЦ=15; ЧДЦ=2; ЧРД=.; ЧГ=0");
				Price.DiscountRate = Формат(Работа.ПроцентСкидки,"ЧЦ=15; ЧДЦ=2; ЧРД=.; ЧГ=0");
				Price.DiscountPrice = Формат(Работа.СуммаСкидки,"ЧЦ=15; ЧДЦ=2; ЧРД=.; ЧГ=0");
				OPCode.PriceType = Price;
				
				DescriptionsType = ФабрикаXDTO.Тип("http://wa.dms.webservice/AppointmentGetRequest", "ArrayOfDescription");
				Descriptions = ФабрикаXDTO.Создать(DescriptionsType);
				OPCode.Descriptions = Descriptions;   				
				CausesType = ФабрикаXDTO.Тип("http://wa.dms.webservice/AppointmentGetRequest", "ArrayOfCause");
				Causes = ФабрикаXDTO.Создать(CausesType);
				OPCode.Causes = Causes;   				
				CorrectionsType = ФабрикаXDTO.Тип("http://wa.dms.webservice/AppointmentGetRequest", "ArrayOfCorrection");
				Corrections = ФабрикаXDTO.Создать(CorrectionsType);
				OPCode.Corrections = Corrections;
				
				PartsType = ФабрикаXDTO.Тип("http://wa.dms.webservice/AppointmentGetRequest", "ArrayOfPart");
				Parts = ФабрикаXDTO.Создать(PartsType);
				OPCode.Parts = Parts;  				
				SubletsType = ФабрикаXDTO.Тип("http://wa.dms.webservice/AppointmentGetRequest", "ArrayOfSublet");
				Sublets = ФабрикаXDTO.Создать(SubletsType);
				OPCode.Sublets = Sublets;  				
				MISCsType = ФабрикаXDTO.Тип("http://wa.dms.webservice/AppointmentGetRequest", "ArrayOfMISC");
				MISCs = ФабрикаXDTO.Создать(MISCsType);
				OPCode.MISCs = MISCs; 				
				OPCodes.OPCode.Добавить(OPCode);
			КонецЦикла;			
			RequestItemJobs.OPCodes = OPCodes; 
            RequestItems.RequestItem.Добавить(RequestItemJobs);
			
            // ТОВАРЫ
			RequestItemJobs = ФабрикаXDTO.Создать(RequestItemType); 
            RequestItemJobs.ServiceLineNumber = "2";
			RequestItemJobs.ServiceLineStatus = "";
			RequestItemJobs.RequestCode = "Request_Part";
			RequestItemJobs.RequestDescription = "";
			RequestItemJobs.CPSIND = "";
			RequestItemJobs.WorkType = "1";    
			RequestItemJobs.ServiceType	= Выборка.ВидРемонта.КраткоеОбозначение;
            RequestItemJobs.TCEmployeeID = "";
			RequestItemJobs.TCEmployeeName = "";
			
			CommentsType = ФабрикаXDTO.Тип("http://wa.dms.webservice/AppointmentGetRequest", "ArrayOfComment");
			Comments = ФабрикаXDTO.Создать(CommentsType);
			RequestItemJobs.Comments = Comments;    			
			DescriptionsType = ФабрикаXDTO.Тип("http://wa.dms.webservice/AppointmentGetRequest", "ArrayOfDescription");
			Descriptions = ФабрикаXDTO.Создать(DescriptionsType);
			RequestItemJobs.Descriptions = Descriptions;
			
			OPCodes = ФабрикаXDTO.Создать(OPCodesType);			
			OPCodeType = ФабрикаXDTO.Тип("http://wa.dms.webservice/AppointmentGetRequest", "OPCode");
			OPCode = ФабрикаXDTO.Создать(OPCodeType); 
            OPCode.SequenceNumber = "";
			OPCode.Code = "OP_Part";
 			OPCode.Description = "";
			OPCode.EstimatedHours = "";   
			OPCode.ActualHours = "";
			OPCode.SkillLevel = "";
			OPCode.ServiceType = КраткоеОбозначение;
            OPCode.Quantity = "";
			
			PriceType = ФабрикаXDTO.Тип("http://wa.dms.webservice/AppointmentGetRequest", "PriceType");
			Price = ФабрикаXDTO.Создать(PriceType); 
			OPCode.PriceType = Price;       
			DescriptionsType = ФабрикаXDTO.Тип("http://wa.dms.webservice/AppointmentGetRequest", "ArrayOfDescription");
			Descriptions = ФабрикаXDTO.Создать(DescriptionsType);
			OPCode.Descriptions = Descriptions;  			
			CausesType = ФабрикаXDTO.Тип("http://wa.dms.webservice/AppointmentGetRequest", "ArrayOfCause");
			Causes = ФабрикаXDTO.Создать(CausesType);
			OPCode.Causes = Causes;                			
			CorrectionsType = ФабрикаXDTO.Тип("http://wa.dms.webservice/AppointmentGetRequest", "ArrayOfCorrection");
			Corrections = ФабрикаXDTO.Создать(CorrectionsType);
			OPCode.Corrections = Corrections;
			
			PartsType = ФабрикаXDTO.Тип("http://wa.dms.webservice/AppointmentGetRequest", "ArrayOfPart");
			Parts = ФабрикаXDTO.Создать(PartsType); 			
			ЗапросТовары = Новый Запрос;
			ЗапросТовары.Параметры.Вставить("ДатаЗаявки", Выборка.Дата);
			ЗапросТовары.Параметры.Вставить("ЗаявкаСсылка", Выборка.Ссылка);
			ЗапросТовары.Параметры.Вставить("Организация", Выборка.Ссылка.Организация);
			ЗапросТовары.Текст = "ВЫБРАТЬ
			                     |	ЗаявкаНаРемонтТовары.НомерСтроки,
			                     |	ЗаявкаНаРемонтТовары.Номенклатура.Наименование КАК Наименование,
			                     |	ЗаявкаНаРемонтТовары.Номенклатура.Артикул КАК Артикул,
			                     |	ЗаявкаНаРемонтТовары.ЕдиницаИзмерения.Наименование КАК ЕдиницаИзмерения,
								 |	ЗаявкаНаРемонтТовары.Номенклатура.Производитель.Родитель КАК Производитель,
			                     |	ЗаявкаНаРемонтТовары.Количество,
			                     |	ЗаявкаНаРемонтТовары.Цена,
			                     |	ЗаявкаНаРемонтТовары.СуммаВсего,
			                     |	ЗаявкаНаРемонтТовары.ПроцентСкидки,
			                     |	ЗаявкаНаРемонтТовары.СуммаСкидки,
			                     |	ЗаявкаНаРемонтТовары.ПроцентСкидкиСтроки,
			                     |	ЗаявкаНаРемонтТовары.СуммаСкидкиСтроки,
			                     |	ЕСТЬNULL(ОстаткиТоваровКомпанииОстатки.КоличествоОстаток, 0) - ЕСТЬNULL(ОстаткиТоваровКомпанииОстатки.РезервОстаток, 0) КАК СвободныйОстаток
			                     |ИЗ
			                     |	Документ.ЗаявкаНаРемонт.Товары КАК ЗаявкаНаРемонтТовары
			                     |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ОстаткиТоваровКомпании.Остатки(&ДатаЗаявки, СкладКомпании.Организация = &Организация) КАК ОстаткиТоваровКомпанииОстатки
			                     |		ПО ЗаявкаНаРемонтТовары.Номенклатура = ОстаткиТоваровКомпанииОстатки.Номенклатура
			                     |ГДЕ
			                     |	ЗаявкаНаРемонтТовары.Ссылка = &ЗаявкаСсылка";
						   
			РезультатТовары = ЗапросТовары.Выполнить().Выгрузить();
			Для Каждого СтрокаТовар Из РезультатТовары Цикл
				PartType = ФабрикаXDTO.Тип("http://wa.dms.webservice/AppointmentGetRequest", "Part");
				Part = ФабрикаXDTO.Создать(PartType); 
	            Part.SequenceNumber = СтрокаТовар.НомерСтроки;      				
				Part.PartNumber = СтрокаТовар.Артикул;
				Если СтрокаТовар.Производитель = Справочники.Производители.Hyundai Тогда
					Part.PartType = "1";
				Иначе
					Part.PartType = "2";
				КонецЕсли;  				
                Part.PartDescription = СтрокаТовар.Наименование; 				
				Если СтрокаТовар.СвободныйОстаток = 0 Тогда
					Part.StockQuantity = "0";
					Part.StockStatus = "unavailable";
				Иначе        		
					Part.StockQuantity = Формат(СтрокаТовар.СвободныйОстаток, "ЧЦ=15; ЧДЦ=2; ЧРД=.; ЧГ=0");
					Если СтрокаТовар.СвободныйОстаток >= СтрокаТовар.Количество Тогда
						Part.StockStatus = "available";
					Иначе
						Part.StockStatus = "unavailable";
                    КонецЕсли;         
				КонецЕсли;
                Part.DisplayPartNumber = Part.PartNumber;
				Part.PackageCode = КодПакетаТО;
				Part.AdditionalType = "0";
				Part.DocumentNo = "";
				Part.DocumentType = "";
				Part.UnitOfMeasure = СтрокаТовар.ЕдиницаИзмерения; 				
		        Part.Quantity = Формат(СтрокаТовар.Количество, "ЧЦ=15; ЧДЦ=2; ЧРД=.; ЧГ=0");
				Part.ServiceType = Выборка.ВидРемонта.КраткоеОбозначение;
				
                PriceType = ФабрикаXDTO.Тип("http://wa.dms.webservice/AppointmentGetRequest", "PriceType");
				Price = ФабрикаXDTO.Создать(PriceType); 
				Price.UnitPrice = Формат(СтрокаТовар.Цена, "ЧЦ=15; ЧДЦ=2; ЧРД=.; ЧГ=0");
				Price.TotalPrice = Формат(СтрокаТовар.СуммаВсего, "ЧЦ=15; ЧДЦ=2; ЧРД=.; ЧГ=0");
				Price.TotalPriceIncludeTax = Формат(СтрокаТовар.СуммаВсего, "ЧЦ=15; ЧДЦ=2; ЧРД=.; ЧГ=0");
				Price.DiscountRate = Формат(?(обЗначениеНеЗаполнено(СтрокаТовар.ПроцентСкидки), СтрокаТовар.ПроцентСкидкиСтроки, СтрокаТовар.ПроцентСкидки),"ЧЦ=15; ЧДЦ=2; ЧРД=.; ЧГ=0");
				Price.DiscountPrice = Формат(СтрокаТовар.СуммаСкидки + СтрокаТовар.СуммаСкидкиСтроки,"ЧЦ=15; ЧДЦ=2; ЧРД=.; ЧГ=0");
				Part.PriceType = Price;
				
				DescriptionsType = ФабрикаXDTO.Тип("http://wa.dms.webservice/AppointmentGetRequest", "ArrayOfDescription");
				Descriptions = ФабрикаXDTO.Создать(DescriptionsType);
				Part.Descriptions = Descriptions;  
				Parts.Part.Добавить(Part);
			КонецЦикла;			
			OPCode.Parts = Parts; 
			SubletsType = ФабрикаXDTO.Тип("http://wa.dms.webservice/AppointmentGetRequest", "ArrayOfSublet");
			Sublets = ФабрикаXDTO.Создать(SubletsType);
			OPCode.Sublets = Sublets; 
			MISCsType = ФабрикаXDTO.Тип("http://wa.dms.webservice/AppointmentGetRequest", "ArrayOfMISC");
			MISCs = ФабрикаXDTO.Создать(MISCsType);
			OPCode.MISCs = MISCs; 
			
			OPCodes.OPCode.Добавить(OPCode);
			RequestItemJobs.OPCodes = OPCodes; 
            RequestItems.RequestItem.Добавить(RequestItemJobs);
            Appointment.RequestItems = RequestItems;
			
			// Онлайн-бронирование, если есть
			мзОнлайнБронирование = РегистрыСведений.ОнлайнБронированиеЗаявок.СоздатьМенеджерЗаписи();
			мзОнлайнБронирование.ЗаявкаНаРемонт = Выборка.Ссылка;
			мзОнлайнБронирование.Прочитать();
			Если мзОнлайнБронирование.Выбран() Тогда
				Appointment.ExternalBookingID = мзОнлайнБронирование.IDБронирования;
			КонецЕсли;
			
			Appointments.Appointment.Добавить(Appointment);
		КонецЦикла;
	КонецЕсли;

	AppointmentGet.Appointments = Appointments;
	AppointmentGet = обПолучитьВозвратWAError("http://wa.dms.webservice/AppointmentGetRequest",AppointmentGetRequest,AppointmentGet,"1",ТаблицаОщибок);
	Возврат AppointmentGet;  	   
КонецФункции

Функция AppointmentChange(AppointmentChangeRequest)
	// Вставить содержимое обработчика.
	AppointmentChangeType = ФабрикаXDTO.Тип("http://wa.dms.webservice/AppointmentGetRequest", "AppointmentChangeResponse");
	AppointmentChange = ФабрикаXDTO.Создать(AppointmentChangeType);   
	
	ТаблицаОщибок = Новый ТаблицаЗначений;
	ТаблицаОщибок.Колонки.Добавить("Код", Новый ОписаниеТипов("Строка"));
	ТаблицаОщибок.Колонки.Добавить("ТекстОшибки", Новый ОписаниеТипов("Строка"));
	
	Попытка
		НомерЗаявкиНаРемонт = AppointmentChangeRequest.AppointmentChange.DMSAppointmentNo;
	Исключение
		НоваяСтрока = ТаблицаОщибок.Добавить();
		НоваяСтрока.Код = "AC30";
		НоваяСтрока.ТекстОшибки = "Отсутствует номер заявки на ремонт";
		AppointmentChange = обПолучитьВозвратWAError("http://wa.dms.webservice/AppointmentGetRequest",AppointmentChangeRequest,AppointmentChange,"-1",ТаблицаОщибок);
		Возврат AppointmentChange;   
	КонецПопытки; 
	
	Попытка
		IDЗаявкиНаРемонт = AppointmentChangeRequest.AppointmentChange.DMSAppointmentID;
	Исключение
		НоваяСтрока = ТаблицаОщибок.Добавить();
		НоваяСтрока.Код = "AC30";
		НоваяСтрока.ТекстОшибки = "Отсутствует идентификатор заявки на ремонт";
		AppointmentChange = обПолучитьВозвратWAError("http://wa.dms.webservice/AppointmentGetRequest",AppointmentChangeRequest,AppointmentChange,"-1",ТаблицаОщибок);
		Возврат AppointmentChange;   
	КонецПопытки;
	
   	Попытка
		ДатаВремяНачалаПриемки = AppointmentChangeRequest.AppointmentChange.AppointmentDateTimeLocal;
	Исключение
		ДатаВремяНачалаПриемки = Дата('00010101');
	КонецПопытки;
	Если ЗначениеЗаполнено(ДатаВремяНачалаПриемки) И Час(ДатаВремяНачалаПриемки) = 23 Тогда
		ДатаВремяНачалаПриемки = НачалоДня(ДатаВремяНачалаПриемки + 3600) + 28800; // 8 часов следующего дня
	КонецЕсли;
	
	Попытка
		ДатаЗаявки = AppointmentChangeRequest.AppointmentChange.OpenDateTimeLocal;
	Исключение
		ДатаЗаявки = Дата('00010101');
	КонецПопытки;  
    Попытка
		ВидРемонта = AppointmentChangeRequest.AppointmentChange.ServiceType;
	Исключение
		ВидРемонта = "";
	КонецПопытки;  
    Попытка
		ТипОплаты = AppointmentChangeRequest.AppointmentChange.PaymentMethod;
	Исключение
		ТипОплаты = "";
	КонецПопытки;   
    Попытка
		КодМастера = AppointmentChangeRequest.AppointmentChange.SAEmployeeID;
	Исключение
		КодМастера = "";
	КонецПопытки;     
	Попытка
		НаименованиеМастера = AppointmentChangeRequest.AppointmentChange.SAEmployeeName;
	Исключение
		НаименованиеМастера = "";
	КонецПопытки;     
	
	 // СОГЛАСИЕ НА ОБРАБОТКУ ПД ЗАШИТО В Options
	Попытка
		МассивОпций = AppointmentChangeRequest.AppointmentChange.Options;  
		Для Каждого Опция Из МассивОпций.Option Цикл
			Если Опция.OptionName = "PersonalInfoAgreeYN" Тогда
				Согласие = Опция.OptionValue; // “N” – ложь, “Y” – истина
			КонецЕсли;
		КонецЦикла; 
	Исключение
		Согласие = "";
	КонецПопытки;

	Попытка
		ПричинаОбращения = AppointmentChangeRequest.AppointmentChange.CustomerComment;    
	Исключение
		ПричинаОбращения = "";
	КонецПопытки;
	
	// Заявка на бесконтактное обслуживание
	Попытка
		Бесконтактно = AppointmentChangeRequest.AppointmentChange.Contactless = "1";
	Исключение
		Бесконтактно = Ложь;
	КонецПопытки;
	
	МастерСсылка = Справочники.Сотрудники.ПустаяСсылка();
	Если ЗначениеЗаполнено(КодМастера) Тогда
		МастерСсылка = Справочники.Сотрудники.НайтиПоКоду(КодМастера);
	КонецЕсли;  
	
	СозданиеНовойЗаявки = Ложь; 
	Если ЗначениеЗаполнено(IDЗаявкиНаРемонт) Тогда         				
		Попытка
			ID = Новый УникальныйИдентификатор(IDЗаявкиНаРемонт);
		Исключение
			НоваяСтрока = ТаблицаОщибок.Добавить();
			НоваяСтрока.Код = "AC30";
			НоваяСтрока.ТекстОшибки = "Некорректный идентификатор заявки на ремонт";
			AppointmentChange = обПолучитьВозвратWAError("http://wa.dms.webservice/AppointmentGetRequest",AppointmentChangeRequest,AppointmentChange,"-1",ТаблицаОщибок);
			Возврат AppointmentChange;   		
		КонецПопытки;			
		ЗаявкаНаРемонтСсылка = Документы.ЗаявкаНаРемонт.ПолучитьСсылку(ID);
		ЗаявкаНаРемонтОбъект = ЗаявкаНаРемонтСсылка.ПолучитьОбъект();	
		Если ЗаявкаНаРемонтОбъект = Неопределено Тогда
			НоваяСтрока = ТаблицаОщибок.Добавить();
			НоваяСтрока.Код = "AC30";
			НоваяСтрока.ТекстОшибки = "Заявка на ремонт с указанным идентификатором не найдена";
			AppointmentChange = обПолучитьВозвратWAError("http://wa.dms.webservice/AppointmentGetRequest",AppointmentChangeRequest,AppointmentChange,"-1",ТаблицаОщибок);
			Возврат AppointmentChange;   		
		КонецЕсли;
		
	ИначеЕсли ЗначениеЗаполнено(НомерЗаявкиНаРемонт) Тогда         				
		ЗаявкаНаРемонтСсылка = Документы.ЗаявкаНаРемонт.НайтиПоНомеру(НомерЗаявкиНаРемонт, ТекущаяДата());
		Если ЗначениеЗаполнено(ЗаявкаНаРемонтСсылка) Тогда
			ЗаявкаНаРемонтОбъект = ЗаявкаНаРемонтСсылка.ПолучитьОбъект();	
		Иначе
			НоваяСтрока = ТаблицаОщибок.Добавить();
			НоваяСтрока.Код = "AC30";
			НоваяСтрока.ТекстОшибки = "Заявка на ремонт с указанным номером не найдена";
			AppointmentChange = обПолучитьВозвратWAError("http://wa.dms.webservice/AppointmentGetRequest",AppointmentChangeRequest,AppointmentChange,"-1",ТаблицаОщибок);
			Возврат AppointmentChange;   		
		КонецЕсли;
		
	Иначе // Create Appointment - запрещено, кроме онлайн-бронирования!!!				
		СозданиеНовойЗаявки = Истина;
		IDОнлайнБронирования = "";
		// онлайн-бронирование записи на ремонт
		Попытка
			IDОнлайнБронирования = AppointmentChangeRequest.AppointmentChange.ExternalBookingID;
		Исключение
			НоваяСтрока = ТаблицаОщибок.Добавить();
			НоваяСтрока.Код = "WA03";
			НоваяСтрока.ТекстОшибки = "Создать Заявку на ремонт можно только в АРМ Запись на ремонт!";
			AppointmentChange = обПолучитьВозвратWAError("http://wa.dms.webservice/AppointmentGetRequest",AppointmentChangeRequest,AppointmentChange,"-1",ТаблицаОщибок);
			Возврат AppointmentChange;
		КонецПопытки;
		Если обЗначениеНеЗаполнено(IDОнлайнБронирования) Тогда
			НоваяСтрока = ТаблицаОщибок.Добавить();
			НоваяСтрока.Код = "WA03";
			НоваяСтрока.ТекстОшибки = "Не указан идентификатор онлайн-бронирования.";
			AppointmentChange = обПолучитьВозвратWAError("http://wa.dms.webservice/AppointmentGetRequest",AppointmentChangeRequest,AppointmentChange,"-1",ТаблицаОщибок);
			Возврат AppointmentChange;
		КонецЕсли;
		
		Попытка
			DealerID = AppointmentChangeRequest.TransactionHeader.DealerID;
		Исключение
			НоваяСтрока = ТаблицаОщибок.Добавить();
			НоваяСтрока.Код = "WA03";
			НоваяСтрока.ТекстОшибки = "Отсутствует идентификатор дилера";
			AppointmentChange = обПолучитьВозвратWAError("http://wa.dms.webservice/AppointmentGetRequest",AppointmentChangeRequest,AppointmentChange,"-1",ТаблицаОщибок);
			Возврат AppointmentChange;   
		КонецПопытки;		
		Подразделение = Справочники.ПодразделенияКомпании.НайтиПоРеквизиту("ДилерИД", DealerID);
		Если обЗначениеНеЗаполнено(Подразделение) Тогда
			НоваяСтрока = ТаблицаОщибок.Добавить();
			НоваяСтрока.Код = "WA03";
			НоваяСтрока.ТекстОшибки = "Подразделение для указанного дилера (" + DealerID + ") не найдено";
			AppointmentChange = обПолучитьВозвратWAError("http://wa.dms.webservice/AppointmentGetRequest",AppointmentChangeRequest,AppointmentChange,"-1",ТаблицаОщибок);
			Возврат AppointmentChange;   
		КонецЕсли;
		
		Если обЗначениеНеЗаполнено(ДатаВремяНачалаПриемки) Тогда  		
			НоваяСтрока = ТаблицаОщибок.Добавить();
			НоваяСтрока.Код	= "AC29";
			НоваяСтрока.ТекстОшибки = "Не указаны дата/время начала приемки.";
			AppointmentChange = обПолучитьВозвратWAError("http://wa.dms.webservice/AppointmentGetRequest",AppointmentChangeRequest,AppointmentChange,"-1",ТаблицаОщибок);
			Возврат AppointmentChange;   		
		КонецЕсли;
		
		Если обЗначениеНеЗаполнено(ПричинаОбращения) Тогда  		
			НоваяСтрока 			= ТаблицаОщибок.Добавить();
			НоваяСтрока.Код 		= "AC29";
			НоваяСтрока.ТекстОшибки = "Не указана причина обращения.";
			AppointmentChange 		= обПолучитьВозвратWAError("http://wa.dms.webservice/AppointmentGetRequest",AppointmentChangeRequest,AppointmentChange,"-1",ТаблицаОщибок);
			Возврат AppointmentChange;   		
		КонецЕсли;
		
		ЗаявкаНаРемонтОбъект = Документы.ЗаявкаНаРемонт.СоздатьДокумент();
		ЗаявкаНаРемонтОбъект.ОбработкаЗаполнения(Неопределено);
		ЗаявкаНаРемонтОбъект.ХозОперация = Справочники.ХозОперации.ЗаявкаНаРемонт;
		ЗаявкаНаРемонтОбъект.ПодразделениеКомпании = Подразделение;
		ЗаявкаНаРемонтОбъект.Организация = Подразделение.Организация;
		ЗаявкаНаРемонтОбъект.Цех = Справочники.Цеха.ОсновнойЦех;
		ЗаявкаНаРемонтОбъект.ВидРемонта = Справочники.ВидыРемонта.КоммерческийРемонт;
		ЗаявкаНаРемонтОбъект.ДатаНачала = ДатаВремяНачалаПриемки;
		ЗаявкаНаРемонтОбъект.ДатаОкончания = ДатаВремяНачалаПриемки + 1800; // для онлайн-бронирования берём 1800 - отправлено в Мир Хендэ;  			
		
		ВыбранныйЦех = НайтиЦехДляПриемки(DealerID, ДатаВремяНачалаПриемки);
		Если ЗначениеЗаполнено(ВыбранныйЦех) Тогда
			ЗаявкаНаРемонтОбъект.ХозОперация = Справочники.ХозОперации.ПланРемонта;
			ЗаявкаНаРемонтОбъект.Цех = ВыбранныйЦех;
			НоваяСтрокаПланирование = ЗаявкаНаРемонтОбъект.Планирование.Добавить();
			НоваяСтрокаПланирование.Авторабота = Справочники.Автоработы.Приемка;
			НоваяСтрокаПланирование.РабочееМесто = ВыбранныйЦех; 
			НоваяСтрокаПланирование.НачалоВыполнения = ДатаВремяНачалаПриемки;
			НоваяСтрокаПланирование.ОкончаниеВыполнения = ДатаВремяНачалаПриемки + 1800;		
			ЗаявкаНаРемонтОбъект.ОбработкаРеквизита("Планирование.НачалоВыполнения", НоваяСтрокаПланирование);
		КонецЕсли;					
		
		Попытка
			VIN = AppointmentChangeRequest.AppointmentChange.Vehicle.VIN;  
		Исключение
			VIN = "";	
		КонецПопытки;
		Попытка
			КодМоделиWA = AppointmentChangeRequest.AppointmentChange.Vehicle.ModelCode;  
		Исключение
			КодМоделиWA = "";	
		КонецПопытки;
		Попытка
			МодельНаименование = AppointmentChangeRequest.AppointmentChange.Vehicle.ModelName;  
		Исключение
			МодельНаименование = "Hyundai";	
		КонецПопытки;
		Попытка
			ЗаявкаНаРемонтОбъект.ГосНомер = AppointmentChangeRequest.AppointmentChange.Vehicle.LicensePlateNo;  
		Исключение
			ЗаявкаНаРемонтОбъект.ГосНомер = "";	
		КонецПопытки;
		Если ЗначениеЗаполнено(VIN) Тогда
			ЗаявкаНаРемонтОбъект.Автомобиль = Справочники.Автомобили.НайтиПоРеквизиту("VIN", VIN);
			Если обЗначениеНеЗаполнено(ЗаявкаНаРемонтОбъект.Автомобиль) Тогда
				ОбъектАвтомобиль = Справочники.Автомобили.СоздатьЭлемент();
				ОбъектАвтомобиль.УстановитьНовыйКод();
				ОбъектАвтомобиль.VIN = VIN;
				Если ЗначениеЗаполнено(КодМоделиWA) Тогда
					ОбъектАвтомобиль.Модель = Справочники.Модели.НайтиПоРеквизиту("КодМодели", КодМоделиWA);
				КонецЕсли;
				ОбъектАвтомобиль.ФормированиеНаименованияАвтомобиля(ЗаявкаНаРемонтОбъект.ГосНомер);
				ОбъектАвтомобиль.Комментарий = "Создан автоматически при онлайн-бронировании из Мир Хендэ";
				
				ОбъектАвтомобиль.ОбменДанными.Загрузка = Истина;
				Попытка
					ОбъектАвтомобиль.Записать();
				Исключение
				КонецПопытки;
				ЗаявкаНаРемонтОбъект.Автомобиль = ОбъектАвтомобиль.Ссылка;
			КонецЕсли;
		Иначе
			НоваяСтрока = ТаблицаОщибок.Добавить();
			НоваяСтрока.Код = "WA03";
			НоваяСтрока.ТекстОшибки = "Отсутствует VIN автомобиля.";
			AppointmentChange = обПолучитьВозвратWAError("http://wa.dms.webservice/AppointmentGetRequest",AppointmentChangeRequest,AppointmentChange,"-1",ТаблицаОщибок);
			Возврат AppointmentChange;   
		КонецЕсли;		
		
		ЗапросДиспетчер = Новый Запрос();
		ЗапросДиспетчер.УстановитьПараметр("ГруппаПодразделений", Подразделение.Родитель);
		ЗапросДиспетчер.УстановитьПараметр("МастерПриемщик", Справочники.Должности.МастерПриемщик);
		ЗапросДиспетчер.Текст =
		"ВЫБРАТЬ
		|	Сотрудники.Ссылка КАК Диспетчер
		|ИЗ
		|	Справочник.Сотрудники КАК Сотрудники
		|ГДЕ
		|	Сотрудники.Подразделение В ИЕРАРХИИ(&ГруппаПодразделений)
		|	И Сотрудники.Должность = &МастерПриемщик
		|	И НЕ Сотрудники.ФлагУволен";
		
		Результат = ЗапросДиспетчер.Выполнить().Выбрать();
		Если Результат.Следующий() Тогда
			МастерСсылка = Результат.Диспетчер;
		Иначе
			НоваяСтрока = ТаблицаОщибок.Добавить();
			НоваяСтрока.Код = "WA03";
			НоваяСтрока.ТекстОшибки = "Не найден мастер-приемщик.";
			AppointmentChange = обПолучитьВозвратWAError("http://wa.dms.webservice/AppointmentGetRequest",AppointmentChangeRequest,AppointmentChange,"-1",ТаблицаОщибок);
			Возврат AppointmentChange;   		
		КонецЕсли;
		
		ЗаявкаНаРемонтОбъект.Комментарий = "Создан автоматически при онлайн-бронировании из Мир Хендэ";		
	КонецЕсли; // конец блока определения объекта ЗаявкаНаРемонтОбъект

	// Изменение реквизитов в заявке
	Попытка
		DMSVehicleNo = AppointmentChangeRequest.AppointmentChange.Vehicle.DMSVehicleNo;  
	Исключение
		DMSVehicleNo = "";	
	КонецПопытки;
	Если ЗначениеЗаполнено(DMSVehicleNo) Тогда
		АвтомобильСсылка = Справочники.Автомобили.НайтиПоКоду(DMSVehicleNo);
		Если АвтомобильСсылка.Пустая() Тогда
			НоваяСтрока = ТаблицаОщибок.Добавить();
			НоваяСтрока.Код = "WA03";
			НоваяСтрока.ТекстОшибки = "Автомобиль с указанным кодом не найден";
			AppointmentChange = обПолучитьВозвратWAError("http://wa.dms.webservice/AppointmentGetRequest",AppointmentChangeRequest,AppointmentChange,"-1",ТаблицаОщибок);
			Возврат AppointmentChange;
		Иначе
			ЗаявкаНаРемонтОбъект.Автомобиль = АвтомобильСсылка;
		КонецЕсли;   			
	КонецЕсли; 		
		
	Если ЗначениеЗаполнено(ТипОплаты) Тогда
		Если ТипОплаты = "1" Тогда
			ЗаявкаНаРемонтОбъект.ВидОплаты = Перечисления.ВидыОплаты.НаличныйРасчет;
		ИначеЕсли ТипОплаты = "3" Тогда 
			ЗаявкаНаРемонтОбъект.ВидОплаты = Перечисления.ВидыОплаты.БанковскаяКарта;
		ИначеЕсли ТипОплаты = "2" Тогда 
			ЗаявкаНаРемонтОбъект.ВидОплаты = Перечисления.ВидыОплаты.БезналичныйРасчет;
		КонецЕсли;   
	КонецЕсли;
	
	Если ЗначениеЗаполнено(МастерСсылка) Тогда
		//ЗаявкаНаРемонтОбъект.Мастер = МастерСсылка;
		ЗаявкаНаРемонтОбъект.Диспетчер = МастерСсылка;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПричинаОбращения) Тогда
		ЗаявкаНаРемонтОбъект.ПричинаОбращения = ПричинаОбращения;
	КонецЕсли;

    // КОНТРАГЕНТЫ И КОНТАКТЫ
	ТаблицаКонтрагентов = Новый ТаблицаЗначений;
	ТаблицаКонтрагентов.Колонки.Добавить("CustomerInfoType",	 Новый ОписаниеТипов("Строка"));
	ТаблицаКонтрагентов.Колонки.Добавить("DMSCustomerNo",		 Новый ОписаниеТипов("Строка"));
	ТаблицаКонтрагентов.Колонки.Добавить("FullName",			 Новый ОписаниеТипов("Строка"));
	ТаблицаКонтрагентов.Колонки.Добавить("Gender",				 Новый ОписаниеТипов("Строка"));
    ТаблицаКонтрагентов.Колонки.Добавить("Email",		 		 Новый ОписаниеТипов("Строка"));
	ТаблицаКонтрагентов.Колонки.Добавить("Message",				 Новый ОписаниеТипов("Строка"));
	ТаблицаКонтрагентов.Колонки.Добавить("ContactPersonID",		 Новый ОписаниеТипов("Строка"));
	ТаблицаКонтрагентов.Колонки.Добавить("ContactPersonName",	 Новый ОписаниеТипов("Строка"));
	ТаблицаКонтрагентов.Колонки.Добавить("ContactPersonPhone",	 Новый ОписаниеТипов("Строка"));
	ТаблицаКонтрагентов.Колонки.Добавить("PowerOfAttorney",	     Новый ОписаниеТипов("Строка"));
	ТаблицаКонтрагентов.Колонки.Добавить("DatePowerOfAttorney",	 Новый ОписаниеТипов("Дата"));
	
	ТаблицаАдресов = Новый ТаблицаЗначений;
	ТаблицаАдресов.Колонки.Добавить("DMSCustomerNo", Новый ОписаниеТипов("Строка"));
	ТаблицаАдресов.Колонки.Добавить("AddressType",	 Новый ОписаниеТипов("Строка"));
	ТаблицаАдресов.Колонки.Добавить("FullAddress",	 Новый ОписаниеТипов("Строка"));
	ТаблицаАдресов.Колонки.Добавить("ZipCode",		 Новый ОписаниеТипов("Строка"));
	ТаблицаАдресов.Колонки.Добавить("Region",		 Новый ОписаниеТипов("Строка"));
    ТаблицаАдресов.Колонки.Добавить("District",		 Новый ОписаниеТипов("Строка"));
	ТаблицаАдресов.Колонки.Добавить("City",			 Новый ОписаниеТипов("Строка"));
	ТаблицаАдресов.Колонки.Добавить("Locality",		 Новый ОписаниеТипов("Строка"));
	ТаблицаАдресов.Колонки.Добавить("Street",		 Новый ОписаниеТипов("Строка"));
	ТаблицаАдресов.Колонки.Добавить("House",		 Новый ОписаниеТипов("Строка"));
	ТаблицаАдресов.Колонки.Добавить("Housing",		 Новый ОписаниеТипов("Строка"));
	ТаблицаАдресов.Колонки.Добавить("Flat",			 Новый ОписаниеТипов("Строка"));
	
	ТаблицаТелефонов = Новый ТаблицаЗначений;
	ТаблицаТелефонов.Колонки.Добавить("DMSCustomerNo",		 Новый ОписаниеТипов("Строка"));
	ТаблицаТелефонов.Колонки.Добавить("ContactType",		 Новый ОписаниеТипов("Строка"));
	ТаблицаТелефонов.Колонки.Добавить("ContactValue",		 Новый ОписаниеТипов("Строка"));
	ТаблицаТелефонов.Колонки.Добавить("ContactMethodYN",	 Новый ОписаниеТипов("Строка"));
	
	Попытка
		МассивКонтрагентов = AppointmentChangeRequest.AppointmentChange.Customers;  
	Исключение
		МассивКонтрагентов = Неопределено;
	КонецПопытки;
	
	Если НЕ МассивКонтрагентов = Неопределено Тогда
		Для Каждого Контрагент Из МассивКонтрагентов.Customer Цикл
			НоваяСтрока = ТаблицаКонтрагентов.Добавить();
			Попытка
				НоваяСтрока.CustomerInfoType = Контрагент.CustomerInfoType;
			Исключение
				НоваяСтрока = ТаблицаОщибок.Добавить();
				НоваяСтрока.Код = "WA03";
				НоваяСтрока.ТекстОшибки = "Отсутствует вид контрагента.";
				AppointmentChange = обПолучитьВозвратWAError("http://wa.dms.webservice/AppointmentGetRequest",AppointmentChangeRequest,AppointmentChange,"-1",ТаблицаОщибок);
				Возврат AppointmentChange;       
			КонецПопытки; 
			Если Не (Контрагент.CustomerInfoType = "1" ИЛИ Контрагент.CustomerInfoType = "2") Тогда
				НоваяСтрока = ТаблицаОщибок.Добавить();
				НоваяСтрока.Код = "WA03";
				НоваяСтрока.ТекстОшибки = "Некорректный вид контрагента.";
				AppointmentChange = обПолучитьВозвратWAError("http://wa.dms.webservice/AppointmentGetRequest",AppointmentChangeRequest,AppointmentChange,"-1",ТаблицаОщибок);
				Возврат AppointmentChange;       
			КонецЕсли;			
			Попытка
				НоваяСтрока.DMSCustomerNo = Контрагент.DMSCustomerNo;
			Исключение
				НоваяСтрока.DMSCustomerNo = "";	
			КонецПопытки;  			
			Попытка
				НоваяСтрока.FullName = Контрагент.FullName;
			Исключение
			КонецПопытки;
			Попытка
				НоваяСтрока.Gender = Контрагент.Gender;
			Исключение
			КонецПопытки;
			Попытка
				НоваяСтрока.Email = Контрагент.Email;
			Исключение
			КонецПопытки;
            Попытка
				НоваяСтрока.Message = Контрагент.SpecialMessage.Message;
			Исключение
			КонецПопытки;   
			// ТаблицаАдресов
			Попытка
            	МассивАдресовКонтрагента = Контрагент.Addresses;
			Исключение
				МассивАдресовКонтрагента = Неопределено;
			КонецПопытки;   			
			Если Не МассивАдресовКонтрагента = Неопределено Тогда
				Для Каждого Адрес Из МассивАдресовКонтрагента.Address Цикл
					НоваяСтрокаАдрес = ТаблицаАдресов.Добавить();	
					НоваяСтрокаАдрес.DMSCustomerNo = Контрагент.DMSCustomerNo;
					Попытка
						НоваяСтрокаАдрес.AddressType = Адрес.AddressType;
					Исключение
						НоваяСтрока = ТаблицаОщибок.Добавить();
						НоваяСтрока.Код = "WA03";
						НоваяСтрока.ТекстОшибки = "Некорректный тип адреса контрагента.";
						AppointmentChange = обПолучитьВозвратWAError("http://wa.dms.webservice/AppointmentGetRequest",AppointmentChangeRequest,AppointmentChange,"-1",ТаблицаОщибок);
						Возврат AppointmentChange;    
					КонецПопытки;
					Попытка
						НоваяСтрокаАдрес.FullAddress = Адрес.FullAddress;
					Исключение
					КонецПопытки;
					Попытка
						НоваяСтрокаАдрес.ZipCode = Адрес.ZipCode;
					Исключение
					КонецПопытки;
                    Попытка
						НоваяСтрокаАдрес.Region = Адрес.Region;
					Исключение
					КонецПопытки;
					Попытка
						НоваяСтрокаАдрес.District = Адрес.District;
					Исключение
					КонецПопытки;
                    Попытка
						НоваяСтрокаАдрес.City = Адрес.City;
					Исключение
					КонецПопытки;
                    Попытка
						НоваяСтрокаАдрес.Locality = Адрес.Locality;
					Исключение
					КонецПопытки;
                    Попытка
						НоваяСтрокаАдрес.Street = Адрес.Street;
					Исключение
					КонецПопытки;
                    Попытка
						НоваяСтрокаАдрес.House = Адрес.House;
					Исключение
					КонецПопытки;
                    Попытка
						НоваяСтрокаАдрес.Housing = Адрес.Housing;
					Исключение
					КонецПопытки;
                    Попытка
						НоваяСтрокаАдрес.Flat = Адрес.Flat;
					Исключение
					КонецПопытки;
				КонецЦикла;
			КонецЕсли;			
			//ТаблицаТелефонов
			Попытка
            	МассивКонтактовКонтрагента = Контрагент.Contacts;
			Исключение
				МассивКонтактовКонтрагента = Неопределено;
			КонецПопытки;			
			Если НЕ МассивКонтактовКонтрагента = Неопределено Тогда
				Для Каждого Телефон Из МассивКонтактовКонтрагента.Contact Цикл
					НоваяСтрокаТел = ТаблицаТелефонов.Добавить();	
					НоваяСтрокаТел.DMSCustomerNo = Контрагент.DMSCustomerNo;
					Попытка
						НоваяСтрокаТел.ContactType = Телефон.ContactType;
					Исключение
						НоваяСтрока = ТаблицаОщибок.Добавить();
						НоваяСтрока.Код = "WA03";
						НоваяСтрока.ТекстОшибки = "Отсутствует вид телефона.";
						AppointmentChange = обПолучитьВозвратWAError("http://wa.dms.webservice/AppointmentGetRequest",AppointmentChangeRequest,AppointmentChange,"-1",ТаблицаОщибок);
						Возврат AppointmentChange; 
					КонецПопытки;
					Попытка					
						НоваяСтрокаТел.ContactValue = Телефон.ContactValue;
					Исключение
						НоваяСтрока = ТаблицаОщибок.Добавить();
						НоваяСтрока.Код = "WA03";
						НоваяСтрока.ТекстОшибки = "Отсутствует значение телефона.";
						AppointmentChange = обПолучитьВозвратWAError("http://wa.dms.webservice/AppointmentGetRequest",AppointmentChangeRequest,AppointmentChange,"-1",ТаблицаОщибок);
						Возврат AppointmentChange;      
					КонецПопытки;
					Попытка
						НоваяСтрокаТел.ContactMethodYN = Телефон.ContactMethodYN;
					Исключение
					КонецПопытки;
				КонецЦикла; 
			КонецЕсли;  
			
			Попытка
            	МассивРеквизитовКонтактногоЛица = Контрагент.CorporateInfos;
			Исключение
				МассивРеквизитовКонтактногоЛица = Неопределено;
			КонецПопытки;			
			Если МассивРеквизитовКонтактногоЛица <> Неопределено Тогда
				Для Каждого Реквизит Из МассивРеквизитовКонтактногоЛица.CorporateInfo Цикл
					Если Реквизит.CorporateInfoName = "ContactPerson" Тогда
						НоваяСтрока.ContactPersonName = Реквизит.CorporateInfoValue;	
					ИначеЕсли Реквизит.CorporateInfoName = "ContactNumber" Тогда
						НоваяСтрока.ContactPersonPhone = Реквизит.CorporateInfoValue; 
					ИначеЕсли Реквизит.CorporateInfoName = "ContactPersonID" Тогда
						НоваяСтрока.ContactPersonID = Реквизит.CorporateInfoValue;	
					ИначеЕсли Реквизит.CorporateInfoName = "PowerOfAttorney" Тогда
						НоваяСтрока.PowerOfAttorney = Реквизит.CorporateInfoValue; 
					ИначеЕсли Реквизит.CorporateInfoName = "DatePowerOfAttorney" Тогда
						НоваяСтрока.DatePowerOfAttorney = Реквизит.CorporateInfoValue;	
					КонецЕсли;    
				КонецЦикла;
			КонецЕсли;

		КонецЦикла; 
	КонецЕсли;
	
	ПризнакЗаказчикаСтрока = Ложь;
	ЗаказчикНаименованиеСтрока = "";
	ЗаказчикТелефонСтрока = "";
	
	Для Каждого КонтрСтрока Из ТаблицаКонтрагентов Цикл
		Если СозданиеНовойЗаявки Тогда
			// данные клиента из онлайн-бронирования
			ЗаявкаНаРемонтОбъект.Заказчик = КонтрСтрока.FullName;
			Для Каждого ТелефонСтрока Из ТаблицаТелефонов Цикл
				Если ЗначениеЗаполнено(ТелефонСтрока.ContactValue) Тогда
					НомерТелефона = СокрЛП(ТелефонСтрока.ContactValue);
					ЗаявкаНаРемонтОбъект.КодРегиона = Лев(НомерТелефона, 2);
					НомерТелефона = ОставитьТолькоЦифры(НомерТелефона);
					Если СтрДлина(НомерТелефона) < 11 Тогда
						НоваяСтрока = ТаблицаОщибок.Добавить();
						НоваяСтрока.Код = "AC08";
						НоваяСтрока.ТекстОшибки = "Номер телефона должен содержать не менее 11 цифр";
						AppointmentChange = обПолучитьВозвратWAError("http://wa.dms.webservice/AppointmentGetRequest",AppointmentChangeRequest,AppointmentChange,"-1",ТаблицаОщибок);
						Возврат AppointmentChange;            
					КонецЕсли;
					НомерТелефона = Сред(НомерТелефона, 2, 10);
					ЗаявкаНаРемонтОбъект.КодГорода = Лев(НомерТелефона, 3);
					ЗаявкаНаРемонтОбъект.НомерТелефона = Сред(НомерТелефона, 4);
					ЗаявкаНаРемонтОбъект.ПредставлениеТелефона = ЗаявкаНаРемонтОбъект.КодРегиона + ", " + НомерТелефона;
					Прервать;
				Иначе
					Продолжить;
				КонецЕсли;
			КонецЦикла;
			
		ИначеЕсли ЗначениеЗаполнено(КонтрСтрока.DMSCustomerNo) Тогда
			// модификация контрагента/заказчика
			КонтрСсылка = Справочники.Контрагенты.НайтиПоКоду(КонтрСтрока.DMSCustomerNo);
		    Если КонтрСсылка.Пустая() Тогда                     		
				НоваяСтрока = ТаблицаОщибок.Добавить();
				НоваяСтрока.Код = "AC06";
				НоваяСтрока.ТекстОшибки = "Передан некорректный код заказчика";
				AppointmentChange = обПолучитьВозвратWAError("http://wa.dms.webservice/AppointmentGetRequest",AppointmentChangeRequest,AppointmentChange,"-1",ТаблицаОщибок);
				Возврат AppointmentChange;     
			Иначе
				Если КонтрСтрока.CustomerInfoType = "2" Тогда 
					ЗаявкаНаРемонтОбъект.Заказчик = КонтрСсылка;
					ЗаявкаНаРемонтОбъект.Контрагент = КонтрСсылка;
					ЗаявкаНаРемонтОбъект.КонтактнаяИнформация = киПолучитьПредставлениеКИ(КонтрСсылка,Справочники.ВидыКонтактнойИнформации.ТелефонКонтактный);
				ИначеЕсли КонтрСтрока.CustomerInfoType = "1" Тогда 
					ЗаявкаНаРемонтОбъект.Контрагент = КонтрСсылка;
				КонецЕсли;
				
				КонтрОбъект = КонтрСсылка.ПолучитьОбъект();  			
				Если ЗначениеЗаполнено(КонтрСтрока.Gender) Тогда
					Если КонтрСтрока.Gender = "1" Тогда 
						КонтрОбъект.Пол = Перечисления.ПолФизическихЛиц.Мужской; 
					Иначе
						КонтрОбъект.Пол = Перечисления.ПолФизическихЛиц.Женский; 
			        КонецЕсли;				
				КонецЕсли;  						
				Если ЗначениеЗаполнено(КонтрСтрока.Message) Тогда
					КонтрОбъект.Комментарий = КонтрСтрока.Message;  
				КонецЕсли;             						
				Если ЗначениеЗаполнено(КонтрСтрока.Email) Тогда
					Запись = РегистрыСведений.КонтактнаяИнформация.СоздатьМенеджерЗаписи();
					Запись.Объект = КонтрСсылка;
			   		Запись.Тип = Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты;
					Запись.Вид = Справочники.ВидыКонтактнойИнформации.АдресЭлектроннойПочтыДомашний;                   
					Запись.Представление	= СокрЛП(КонтрСтрока.Email);
					Попытка
						Запись.Записать(Истина);
					Исключение
						НоваяСтрока = ТаблицаОщибок.Добавить();
						НоваяСтрока.Код = "WA03";
						НоваяСтрока.ТекстОшибки = ОписаниеОшибки();
						AppointmentChange = обПолучитьВозвратWAError("http://wa.dms.webservice/AppointmentGetRequest",AppointmentChangeRequest,AppointmentChange,"-1",ТаблицаОщибок);
						Возврат AppointmentChange;                 
					КонецПопытки;
				КонецЕсли;  								
				
				Для Каждого АдресСтрока Из ТаблицаАдресов Цикл
					Если АдресСтрока.DMSCustomerNo <> КонтрСтрока.DMSCustomerNo Тогда
						продолжить;
					КонецЕсли;
					Запись = РегистрыСведений.КонтактнаяИнформация.СоздатьМенеджерЗаписи();
					Запись.Объект = КонтрСсылка;
			   		Запись.Тип = Перечисления.ТипыКонтактнойИнформации.Адрес; 			
					Если АдресСтрока.AddressType =  "1" Тогда
						Запись.Вид = Справочники.ВидыКонтактнойИнформации.АдресЮридический;
					ИначеЕсли АдресСтрока.AddressType = "2" Тогда
						Запись.Вид =  Справочники.ВидыКонтактнойИнформации.АдресФактический;  
					Иначе
						Запись.Вид = Справочники.ВидыКонтактнойИнформации.АдресПочтовый;
					КонецЕсли;    	
					Если ЗначениеЗаполнено(АдресСтрока.ZipCode) Тогда
						Запись.Поле1 = СокрЛП(АдресСтрока.ZipCode);
					КонецЕсли;
					Если ЗначениеЗаполнено(АдресСтрока.Region) Тогда
						Запись.Поле2 = СокрЛП(АдресСтрока.Region);
					КонецЕсли;
					Если ЗначениеЗаполнено(АдресСтрока.District) Тогда
						Запись.Поле3 = СокрЛП(АдресСтрока.District);
					КонецЕсли;
					Если ЗначениеЗаполнено(АдресСтрока.City) Тогда
						Запись.Поле4 = СокрЛП(АдресСтрока.City); 
					КонецЕсли;
					Если ЗначениеЗаполнено(АдресСтрока.Locality) Тогда
						Запись.Поле5 = СокрЛП(АдресСтрока.Locality);
					КонецЕсли;
					Если ЗначениеЗаполнено(АдресСтрока.Street) Тогда
						Запись.Поле6 = СокрЛП(АдресСтрока.Street);
					КонецЕсли;
					Если ЗначениеЗаполнено(АдресСтрока.House) Тогда
						Запись.Поле7 = СокрЛП(АдресСтрока.House);
					КонецЕсли;
					Если ЗначениеЗаполнено(АдресСтрока.Housing) Тогда
						Запись.Поле8 = СокрЛП(АдресСтрока.Housing);
					КонецЕсли;
					Если ЗначениеЗаполнено(АдресСтрока.Flat) Тогда
						Запись.Поле9 = СокрЛП(АдресСтрока.Flat);  
					КонецЕсли;
					
					Запись.Представление = киПолучитьПредставлениеАдреса(Запись);
					Если обЗначениеНеЗаполнено(Запись.Представление) Тогда
						Продолжить;
					КонецЕсли;
					
					Попытка
						Запись.Записать(Истина);
					Исключение
						НоваяСтрока = ТаблицаОщибок.Добавить();
						НоваяСтрока.Код = "WA03";
						НоваяСтрока.ТекстОшибки = ОписаниеОшибки();
						AppointmentChange = обПолучитьВозвратWAError("http://wa.dms.webservice/AppointmentGetRequest",AppointmentChangeRequest,AppointmentChange,"-1",ТаблицаОщибок);
						Возврат AppointmentChange;            
					КонецПопытки;     			
				КонецЦикла; 						
				
				Для Каждого ТелефонСтрока Из ТаблицаТелефонов Цикл 
					Если ТелефонСтрока.DMSCustomerNo <> КонтрСтрока.DMSCustomerNo Тогда
						Если КонтрСтрока.DMSCustomerNo = "" Тогда 
							ЗаказчикТелефонСтрока = ТелефонСтрока.ContactValue; 
							ПризнакЗаказчикаСтрока = Истина;
						КонецЕсли;
						Продолжить;
					КонецЕсли;
					Запись = РегистрыСведений.КонтактнаяИнформация.СоздатьМенеджерЗаписи();
					Запись.Объект = КонтрСсылка;
			   		Запись.Тип = Перечисления.ТипыКонтактнойИнформации.Телефон;  			
					Если ТелефонСтрока.ContactType = "1" Тогда
						Запись.Вид = Справочники.ВидыКонтактнойИнформации.ТелефонДомашний;
					ИначеЕсли ТелефонСтрока.ContactType = "2" Тогда
						Запись.Вид = Справочники.ВидыКонтактнойИнформации.ТелефонКонтактный;
					Иначе
						Запись.Вид = Справочники.ВидыКонтактнойИнформации.ТелефонРабочий;
					КонецЕсли;   
					
					Если ЗначениеЗаполнено(ТелефонСтрока.ContactValue) Тогда
						НомерТелефона = СокрЛП(ТелефонСтрока.ContactValue);
						Запись.Поле1 = Лев(НомерТелефона, 2);
						НомерТелефона = ОставитьТолькоЦифры(НомерТелефона);
						Если СтрДлина(НомерТелефона) < 11 Тогда
							НоваяСтрока = ТаблицаОщибок.Добавить();
							НоваяСтрока.Код = "AC08";
							НоваяСтрока.ТекстОшибки = "Номер телефона должен содержать не менее 11 цифр";
							AppointmentChange = обПолучитьВозвратWAError("http://wa.dms.webservice/AppointmentGetRequest",AppointmentChangeRequest,AppointmentChange,"-1",ТаблицаОщибок);
							Возврат AppointmentChange;            
						КонецЕсли;
						НомерТелефона = Сред(НомерТелефона, 2, 10);
						Запись.Поле2 = Лев(НомерТелефона, 3);
						Запись.Поле3 = Сред(НомерТелефона, 4);
						Запись.Представление = Запись.Поле1 + ", " + Запись.Поле2 + Запись.Поле3;
					Иначе
						Продолжить;
					КонецЕсли;
					Запись.CRM_ПолеХраненияНомера = ПолучитьИндексНомераТелефона(ТелефонСтрока.ContactValue, 11);  		
					
					Попытка
						Запись.Записать(Истина);
					Исключение
						НоваяСтрока = ТаблицаОщибок.Добавить();
						НоваяСтрока.Код = "WA03";
						НоваяСтрока.ТекстОшибки = ОписаниеОшибки();
						AppointmentChange = обПолучитьВозвратWAError("http://wa.dms.webservice/AppointmentGetRequest",AppointmentChangeRequest,AppointmentChange,"-1",ТаблицаОщибок);
						Возврат AppointmentChange;            
					КонецПопытки; 		
				КонецЦикла;  
				
				Если ЗначениеЗаполнено(КонтрСтрока.ContactPersonName) Тогда
					Если ЗначениеЗаполнено(КонтрСтрока.ContactPersonID) Тогда // контактное лицо существует
						КонтЛицо = Справочники.КонтактныеЛица.НайтиПоКоду(КонтрСтрока.ContactPersonID,,,КонтрСсылка);
						Если КонтЛицо = Справочники.КонтактныеЛица.ПустаяСсылка() Тогда
							НоваяСтрока = ТаблицаОщибок.Добавить();
							НоваяСтрока.Код = "WA03";
							НоваяСтрока.ТекстОшибки = "Передан некорректный код контактного лица";
							AppointmentChange = обПолучитьВозвратWAError("http://wa.dms.webservice/AppointmentGetRequest",AppointmentChangeRequest,AppointmentChange,"-1",ТаблицаОщибок);
							Возврат AppointmentChange;   	
						КонецЕсли;
						КонтЛицоОбъект = КонтЛицо.ПолучитьОбъект(); 
					Иначе
						КонтЛицоОбъект = Справочники.КонтактныеЛица.СоздатьЭлемент();
						КонтЛицоОбъект.УстановитьНовыйКод();
						КонтЛицоОбъект.ВедушийКонтрагент = КонтрСсылка;
						КонтЛицоОбъект.Родитель = Справочники.Контрагенты.КонтактныеЛица;
						КонтЛицоОбъект.ФормаСобственности = Перечисления.ФормыСобственности.ЧастноеЛицо;
						КонтЛицоОбъект.ВидКонтрагента = Перечисления.ВидыКонтрагентов.КонтактноеЛицо;
						КонтЛицоОбъект.СогласиеНаОбработкуПерсональныхДанных = Перечисления.ВариантыОтветов.Да;
					КонецЕсли;
					КонтЛицоОбъект.Наименование = КонтрСтрока.ContactPersonName;
					КонтЛицоОбъект.ОбменДанными.Загрузка = Истина;
					КонтЛицоОбъект.Записать();
					
					Если ЗначениеЗаполнено(КонтрСтрока.ContactPersonPhone) Тогда
						Запись = РегистрыСведений.КонтактнаяИнформация.СоздатьМенеджерЗаписи();
						Запись.Объект = КонтЛицоОбъект.Ссылка;
				   		Запись.Тип = Перечисления.ТипыКонтактнойИнформации.Телефон;  			
						Запись.Вид = Справочники.ВидыКонтактнойИнформации.ТелефонКонтактный;							
						НомерТелефона = СокрЛП(КонтрСтрока.ContactPersonPhone);
						Запись.Поле1 = Лев(НомерТелефона, 2);
						НомерТелефона = ОставитьТолькоЦифры(НомерТелефона);
						Если СтрДлина(НомерТелефона) < 11 Тогда
							НоваяСтрока = ТаблицаОщибок.Добавить();
							НоваяСтрока.Код = "WA03";
							НоваяСтрока.ТекстОшибки = "Номер телефона должен содержать не менее 11 цифр";
							AppointmentChange = обПолучитьВозвратWAError("http://wa.dms.webservice/AppointmentGetRequest",AppointmentChangeRequest,AppointmentChange,"-1",ТаблицаОщибок);
							Возврат AppointmentChange;            
						КонецЕсли;
						НомерТелефона = Сред(НомерТелефона, 2, 10);
						Запись.Поле2 = Лев(НомерТелефона, 3);
						Запись.Поле3 = Сред(НомерТелефона, 4);
						Запись.Представление = Запись.Поле1 + ", " + Запись.Поле2 + Запись.Поле3;
						Запись.CRM_ПолеХраненияНомера = ПолучитьИндексНомераТелефона(КонтрСтрока.ContactPersonPhone, 11);
						
						Попытка
							Запись.Записать(Истина);
						Исключение
							НоваяСтрока = ТаблицаОщибок.Добавить();
							НоваяСтрока.Код = "WA03";
							НоваяСтрока.ТекстОшибки = ОписаниеОшибки();
							AppointmentChange = обПолучитьВозвратWAError("http://wa.dms.webservice/AppointmentGetRequest",AppointmentChangeRequest,AppointmentChange,"-1",ТаблицаОщибок);
							Возврат AppointmentChange;            
						КонецПопытки; 			
					КонецЕсли;
				КонецЕсли;
				
				Попытка
					КонтрОбъект.ОбменДанными.Загрузка = Истина;
					КонтрОбъект.Записать();
				Исключение
					НоваяСтрока = ТаблицаОщибок.Добавить();
					НоваяСтрока.Код = "WA03";
					НоваяСтрока.ТекстОшибки = ОписаниеОшибки();
					AppointmentChange = обПолучитьВозвратWAError("http://wa.dms.webservice/AppointmentGetRequest",AppointmentChangeRequest,AppointmentChange,"-1",ТаблицаОщибок);
					Возврат AppointmentChange;          
				КонецПопытки; 					
			КонецЕсли;  					
			
		ИначеЕсли Не Бесконтактно Тогда
			НоваяСтрока = ТаблицаОщибок.Добавить();
			НоваяСтрока.Код = "AC06";
			НоваяСтрока.ТекстОшибки = "Не указан код заказчика в ИБ";
			AppointmentChange = обПолучитьВозвратWAError("http://wa.dms.webservice/AppointmentGetRequest",AppointmentChangeRequest,AppointmentChange,"-1",ТаблицаОщибок);
			Возврат AppointmentChange;                
		КонецЕсли; 					
	КонецЦикла;       	
	
	// Дата/Время окончания планируемых работ
	Если Не СозданиеНовойЗаявки И Не Бесконтактно Тогда
		Попытка
			КонПриемкиЗаявкиНаРемонт = AppointmentChangeRequest.AppointmentChange.DeliveryDateTimeLocal;
		Исключение
			КонПриемкиЗаявкиНаРемонт = Дата('00010101');
		КонецПопытки;
		Если ЗначениеЗаполнено(КонПриемкиЗаявкиНаРемонт) Тогда
			ЗаявкаНаРемонтОбъект.ДатаОкончания = КонПриемкиЗаявкиНаРемонт;
		Иначе
			НоваяСтрока = ТаблицаОщибок.Добавить();
			НоваяСтрока.Код = "AC29";
			НоваяСтрока.ТекстОшибки = "Некорректное дата/время окончания планируемых работ";
			AppointmentChange = обПолучитьВозвратWAError("http://wa.dms.webservice/AppointmentGetRequest",AppointmentChangeRequest,AppointmentChange,"-1",ТаблицаОщибок);
			Возврат AppointmentChange;   		
		КонецЕсли;
	КонецЕсли;
	
	// Пробег
	Попытка
		InMileage = AppointmentChangeRequest.AppointmentChange.InMileage;
	Исключение
		InMileage = "";
	КонецПопытки;  	
	Если ЗначениеЗаполнено(InMileage) Тогда
		Если ТипЗнч(ЗаявкаНаРемонтОбъект.Автомобиль) = Тип("СправочникСсылка.Автомобили") Тогда
		 	Отказ = Справочники.Автомобили.ЗаписьЗначенияРегистраСведения(ЗаявкаНаРемонтОбъект.Автомобиль, Число(InMileage), 
								Перечисления.ДополнительнаяИнформацияАвтомобилей.Пробег, ЗаявкаНаРемонтОбъект.ДатаНачала);
			Если Отказ Тогда
				НоваяСтрока = ТаблицаОщибок.Добавить();
				НоваяСтрока.Код = "AC05";
				НоваяСтрока.ТекстОшибки = "Пробег автомобиля не может быть меньше старого значения.";
				AppointmentChange = обПолучитьВозвратWAError("http://wa.dms.webservice/AppointmentGetRequest",AppointmentChangeRequest,AppointmentChange,"-1",ТаблицаОщибок);
				Возврат AppointmentChange;    
			КонецЕсли;  
		Иначе
			НоваяСтрока = ТаблицаОщибок.Добавить();
			НоваяСтрока.Код = "WA03";
			НоваяСтрока.ТекстОшибки = "Для изменения пробега в заявке нужно указать автомобиль";
			AppointmentChange = обПолучитьВозвратWAError("http://wa.dms.webservice/AppointmentGetRequest",AppointmentChangeRequest,AppointmentChange,"-1",ТаблицаОщибок);
			Возврат AppointmentChange;    
		КонецЕсли;		
	КонецЕсли;  
	
	// Согласие на обработку ПД
	Если ЗначениеЗаполнено(Согласие) Тогда
		НовыйВариант = ?(Согласие = "Y", Перечисления.ВариантыОтветов.Да, Перечисления.ВариантыОтветов.Нет);
		Заказчик = ЗаявкаНаРемонтОбъект.Заказчик;
		Если ТипЗнч(Заказчик) = Тип("СправочникСсылка.Контрагенты") И Заказчик.СогласиеНаОбработкуПерсональныхДанных <> НовыйВариант Тогда
			НоваяСтрока = ТаблицаОщибок.Добавить();
			НоваяСтрока.Код = "WA03";
			НоваяСтрока.ТекстОшибки = "Изменить согласие на обработку персональных данных можно только в карточке Контрагента!";
			AppointmentChange = обПолучитьВозвратWAError("http://wa.dms.webservice/AppointmentGetRequest",AppointmentChangeRequest,AppointmentChange,"-1",ТаблицаОщибок);
			Возврат AppointmentChange;   				 	
		КонецЕсли;		
	КонецЕсли;  

	// Бесконтактная Передача ТС
	ЗаявкаНаРемонтОбъект.БесконтактнаяПередачаТС = Бесконтактно;
	Если Бесконтактно И Не СозданиеНовойЗаявки Тогда
		Если ДатаВремяНачалаПриемки > ЗаявкаНаРемонтОбъект.ДатаНачала Тогда
			Если ЗаявкаНаРемонтОбъект.ХозОперация = Справочники.ХозОперации.ПланРемонта Тогда
				ЗаявкаНаРемонтОбъект.Планирование.Очистить();
				НаборЗаписейГрафикРаботыРесурсов = РегистрыСведений.ГрафикРаботыРесурсов.СоздатьНаборЗаписей();
				НаборЗаписейГрафикРаботыРесурсов.Отбор.Объект.Значение = ЗаявкаНаРемонтСсылка;
				НаборЗаписейГрафикРаботыРесурсов.Отбор.Объект.ВидСравнения = ВидСравнения.Равно;
				НаборЗаписейГрафикРаботыРесурсов.Отбор.Объект.Использование = Истина;
				НаборЗаписейГрафикРаботыРесурсов.Прочитать();
				НаборЗаписейГрафикРаботыРесурсов.Очистить();
				НаборЗаписейГрафикРаботыРесурсов.Записать();
			КонецЕсли;
			
			ЗаявкаНаРемонтОбъект.ХозОперация = Справочники.ХозОперации.ЗаявкаНаРемонт;
			ЗаявкаНаРемонтОбъект.ДатаНачала = ДатаВремяНачалаПриемки;
			ЗаявкаНаРемонтОбъект.ДатаОкончания = ДатаВремяНачалаПриемки + 1800; // для онлайн-бронирования берём 1800 - отправлено в Мир Хендэ;  		
			
			ВыбранныйЦех = НайтиЦехДляПриемки(DealerID, ДатаВремяНачалаПриемки);
			Если ЗначениеЗаполнено(ВыбранныйЦех) Тогда
				ЗаявкаНаРемонтОбъект.ХозОперация = Справочники.ХозОперации.ПланРемонта;
				ЗаявкаНаРемонтОбъект.Цех = ВыбранныйЦех;
				НоваяСтрокаПланирование = ЗаявкаНаРемонтОбъект.Планирование.Добавить();
				НоваяСтрокаПланирование.Авторабота = Справочники.Автоработы.Приемка;
				НоваяСтрокаПланирование.РабочееМесто = ВыбранныйЦех; 
				НоваяСтрокаПланирование.НачалоВыполнения = ДатаВремяНачалаПриемки;
				НоваяСтрокаПланирование.ОкончаниеВыполнения = ДатаВремяНачалаПриемки + 1800;		
				ЗаявкаНаРемонтОбъект.ОбработкаРеквизита("Планирование.НачалоВыполнения", НоваяСтрокаПланирование);
			КонецЕсли;				
		КонецЕсли;
	КонецЕсли;
	
	Попытка
		ЗаявкаНаРемонтОбъект.Записать(РежимЗаписиДокумента.Проведение);
	Исключение
		ЗаявкаНаРемонтОбъект.ОбменДанными.Загрузка = Истина;
		ЗаявкаНаРемонтОбъект.Записать();
	КонецПопытки;
	
	Если СозданиеНовойЗаявки Тогда
		мзОнлайнБронирование = РегистрыСведений.ОнлайнБронированиеЗаявок.СоздатьМенеджерЗаписи();
		мзОнлайнБронирование.ЗаявкаНаРемонт = ЗаявкаНаРемонтОбъект.Ссылка;
		мзОнлайнБронирование.IDБронирования = IDОнлайнБронирования;
		мзОнлайнБронирование.Записать();
	
		мКому = Новый Массив();
		Если DealerID = "RC536" Тогда
			мКому.Добавить("service_sh@hyundai-sokolmotors.ru");
			мКому.Добавить("service_operator@hyundai-sokolmotors.ru");
		Иначе
			мКому.Добавить("service_dm@sokolmotors.ru");
		КонецЕсли;
		
		РуководительСервиса = Подразделение.РуководительСервиса.Сотрудник;
		Если ЗначениеЗаполнено(РуководительСервиса) Тогда
			АдресЭлПочты = киПолучитьПредставлениеКИ(РуководительСервиса, Справочники.ВидыКонтактнойИнформации.АдресЭлектроннойПочтыРабочий);
			Если обЗначениеНеЗаполнено(АдресЭлПочты) Тогда
				АдресЭлПочты = РуководительСервиса.РабочийEmail;
			КонецЕсли;
			Если ЗначениеЗаполнено(АдресЭлПочты) Тогда
				мКому.Добавить(АдресЭлПочты);
			КонецЕсли;
		КонецЕсли;
		
		ТемаПисьма = "Онлайн-бронирование через Мир Хендэ";
		ТелоПисьма = Формат(ТекущаяДата(), "ДФ='дд.ММ.гггг ЧЧ:мм'") + " создана новая Заявка на ремонт № " 
						+ ЗаявкаНаРемонтОбъект.Номер + " на " + Формат(ДатаВремяНачалаПриемки, "ДФ='дд.ММ.гггг ЧЧ:мм.'") + Символы.ПС + Символы.ПС +
						"Время записи можно редактировать в течение 30 минут.";	
		мКопии = Новый Массив();
		г_Функции.СоздатьИОтпраитьЭлПисьмо(мКому, мКопии, ТемаПисьма, ТелоПисьма, ЗаявкаНаРемонтОбъект.Ссылка);
		
		обОтправитьЗапросВWA(Строка(ЗаявкаНаРемонтОбъект.Ссылка.УникальныйИдентификатор()), DealerID, "1", "C");
	КонецЕсли;
	
	AppointmentChange = обПолучитьВозвратWAError("http://wa.dms.webservice/AppointmentGetRequest",AppointmentChangeRequest,AppointmentChange,"1",ТаблицаОщибок,Строка(ЗаявкаНаРемонтОбъект.Ссылка.УникальныйИдентификатор()));
	Возврат AppointmentChange;       
           
КонецФункции       

//Функция возвращает номер телефона в котором присутствуют только символы цифр
Функция ОставитьТолькоЦифры(НомерТелефона)
	ТолькоЦифрыНомера = "";
	Для сч = 1 По СтрДлина(НомерТелефона) Цикл
		СимволИзНомера = Сред(НомерТелефона, сч, 1);
		Если СтрНайти("1234567890", СимволИзНомера) > 0 Тогда
			ТолькоЦифрыНомера = ТолькоЦифрыНомера + СимволИзНомера;
		КонецЕсли;
	КонецЦикла;
	Возврат ТолькоЦифрыНомера;
КонецФункции

//Функция возвращает число - индекс номера телефона
Функция ПолучитьИндексНомераТелефона(НомерТелефона, ЧислоСимволов)
	Префикс = "1";
	ТолькоЦифрыНомера = ОставитьТолькоЦифры(НомерТелефона);
	Возврат ?(НЕ ЗначениеЗаполнено(ТолькоЦифрыНомера), 0, Число(Префикс + Прав(СокрЛП(ТолькоЦифрыНомера), ЧислоСимволов)));
КонецФункции

Функция ПолучитьКодПакетаТО(Автомобиль, ПричинаОбращения)
	мзКодыПакетовТО = РегистрыСведений.КодыПакетовТО.СоздатьМенеджерЗаписи();
	КодМодели = Автомобиль.Модель.КодМодели;
	Если ЗначениеЗаполнено(КодМодели) Тогда
		мзКодыПакетовТО.КодМодели = КодМодели;
	Иначе
		Возврат "";
	КонецЕсли;
	
	НомерТО = ОставитьТолькоЦифры(Лев(ПричинаОбращения, 5));
	Если ЗначениеЗаполнено(НомерТО) Тогда
		мзКодыПакетовТО.НомерТО = Число(НомерТО);
	Иначе
		Возврат "";
	КонецЕсли;
		
	Двигатель = Автомобиль.ВариантКомплектации.ТипДвигателя;
	ТипДвигателя = Строка(Окр(Двигатель.ОбъемДвигателя * 10));
	Если Двигатель.ТипТоплива = Перечисления.ТипыТоплива.Diesel Тогда
		ТипДвигателя = ТипДвигателя + "d";
	КонецЕсли;
	мзКодыПакетовТО.ТипДвигателя = ТипДвигателя;
	
	мзКодыПакетовТО.Прочитать();
	Если мзКодыПакетовТО.Выбран() Тогда
		Возврат мзКодыПакетовТО.КодПакетаТО;
	Иначе
		мзКодыПакетовТО.КодМодели = КодМодели;
		мзКодыПакетовТО.НомерТО = Число(НомерТО);
		мзКодыПакетовТО.ТипДвигателя = ТипДвигателя + "t";
		мзКодыПакетовТО.Прочитать();
		Если мзКодыПакетовТО.Выбран() Тогда
			Возврат мзКодыПакетовТО.КодПакетаТО;
		Иначе
			Возврат "";
		КонецЕсли;
	КонецЕсли;	
КонецФункции

Функция НайтиЦехДляПриемки(КодДилера, ДатаНачалаПриемки)
	ВыбранныйЦех = Справочники.Цеха.ПустаяСсылка();
	
	ЗапросГрафикРесурсов = Новый Запрос();
	ЗапросГрафикРесурсов.УстановитьПараметр("ДатаПриёмки", НачалоДня(ДатаНачалаПриемки));
	ЗапросГрафикРесурсов.Текст =
	"ВЫБРАТЬ
	|	ГрафикРаботыРесурсов.Ресурс1,
	|	ГрафикРаботыРесурсов.НачалоРабочегоВремени,
	|	ГрафикРаботыРесурсов.КонецРабочегоВремени
	|ИЗ
	|	РегистрСведений.ГрафикРаботыРесурсов КАК ГрафикРаботыРесурсов
	|ГДЕ
	|	ГрафикРаботыРесурсов.Дата = &ДатаПриёмки
	|	И ГрафикРаботыРесурсов.Ресурс1 = &Ресурс1";
		
	ВремяНачалаПриёмки = Дата(1, 1, 1) + Час(ДатаНачалаПриемки) * 3600 + Минута(ДатаНачалаПриемки) * 60 + Секунда(ДатаНачалаПриемки);
	ВремяОкончанияПриёмки = ВремяНачалаПриёмки + 1800; // Длительность приёмки в сервис		
	
	НастройкиДилера = Справочники.СМ_НастройкиДилеровХендэ.НайтиПоРеквизиту("КодДилера", КодДилера);
	Если ЗначениеЗаполнено(НастройкиДилера) Тогда
		Для Каждого СтрокаЦех Из НастройкиДилера.ЦехаБронирование Цикл
			ЗапросГрафикРесурсов.УстановитьПараметр("Ресурс1", СтрокаЦех.Цех);
			ГрафикЦеха = ЗапросГрафикРесурсов.Выполнить().Выгрузить();			
			
			ЭтоПодходящийЦех = Истина;
			Для Каждого СтрокаГрафик Из ГрафикЦеха Цикл
				Если ВремяНачалаПриёмки < СтрокаГрафик.КонецРабочегоВремени И ВремяОкончанияПриёмки > СтрокаГрафик.НачалоРабочегоВремени Тогда
					ЭтоПодходящийЦех = Ложь;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			
			Если ЭтоПодходящийЦех Тогда
				ВыбранныйЦех = СтрокаЦех.Цех;
				Прервать;
			КонецЕсли;
		КонецЦикла;			
	КонецЕсли;
	
	Возврат ВыбранныйЦех;
КонецФункции
