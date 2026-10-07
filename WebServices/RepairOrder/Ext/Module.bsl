
Функция RepairOrderGet(RepairOrderGetRequest)
	// Вставить содержимое обработчика.
	
	RepairOrderGetType = ФабрикаXDTO.Тип("http://wa.dms.webservice/RepairOrderGetRequest", "RepairOrderGetResponse");
	RepairOrderGet = ФабрикаXDTO.Создать(RepairOrderGetType);   
	
	ТаблицаОщибок = Новый ТаблицаЗначений;
	ТаблицаОщибок.Колонки.Добавить("Код",	 Новый ОписаниеТипов("Строка"));
	ТаблицаОщибок.Колонки.Добавить("ТекстОшибки",		 Новый ОписаниеТипов("Строка"));    	
	
	Попытка
		НомерЗаявкиНаРемонт = RepairOrderGetRequest.RepairOrderGet.DMSAppointmentNo;
	Исключение
		НомерЗаявкиНаРемонт = "";
	КонецПопытки;       
	Попытка
		IDЗаявкиНаРемонт = RepairOrderGetRequest.RepairOrderGet.DMSAppointmentID;
	Исключение
		IDЗаявкиНаРемонт = "";
	КонецПопытки;       
    Попытка
		НомерЗаказНаряда = RepairOrderGetRequest.RepairOrderGet.DMSRONo;
	Исключение
		НомерЗаказНаряда = "";
	КонецПопытки;       
	Попытка
		IDЗаказНаряда = RepairOrderGetRequest.RepairOrderGet.DMSROID;
	Исключение
		IDЗаказНаряда = "";
	КонецПопытки; 
	
   	Попытка
		НачДатаЗаказНаряда = RepairOrderGetRequest.RepairOrderGet.OpenDateTimeFromLocal;
	Исключение
		НачДатаЗаказНаряда = Дата('00010101');
	КонецПопытки;       
	Попытка
		КонДатаЗаказНаряда = RepairOrderGetRequest.RepairOrderGet.OpenDateTimeToLocal;
	Исключение
		КонДатаЗаказНаряда = Дата('00010101');
	КонецПопытки;
	ЗаданДиапазонДатСоздания = ЗначениеЗаполнено(КонДатаЗаказНаряда) И КонДатаЗаказНаряда > НачДатаЗаказНаряда;
	
	Попытка
		НачДатаИзмененияЗаказНаряда = RepairOrderGetRequest.RepairOrderGet.LastModifiedDateTimeFromUTC;
	Исключение
		НачДатаИзмененияЗаказНаряда = Дата('00010101'); 
	КонецПопытки;
    Попытка
		КонДатаИзмененияЗаказНаряда = RepairOrderGetRequest.RepairOrderGet.LastModifiedDateTimeToUTC;
	Исключение
		КонДатаИзмененияЗаказНаряда = Дата('00010101');
	КонецПопытки;
    Попытка
		СостояниеЗаказНаряда = RepairOrderGetRequest.RepairOrderGet.DMSROStatus;
	Исключение
		СостояниеЗаказНаряда = "";
	КонецПопытки;	
    Попытка
		КодМастера = RepairOrderGetRequest.RepairOrderGet.SAEmployeeID;
	Исключение
		КодМастера = "";
	КонецПопытки;    
	Попытка
		НаименованиеМастера = RepairOrderGetRequest.RepairOrderGet.SAEmployeeName;
	Исключение
		НаименованиеМастера = "";
	КонецПопытки;    
    Попытка
		КодКонтрагента = RepairOrderGetRequest.RepairOrderGet.CustomerGet.DMSCustomerNo;
	Исключение
		КодКонтрагента = "";
	КонецПопытки;   
	Попытка
		ФамилияКонтрагента = RepairOrderGetRequest.RepairOrderGet.CustomerGet.LastName;
		Если СтрДлина(ФамилияКонтрагента)<3 и ФамилияКонтрагента <> ""  Тогда
			НоваяСтрока = ТаблицаОщибок.Добавить();
			НоваяСтрока.Код = "ROG01";
			НоваяСтрока.ТекстОшибки = "Для поиска по фамилии должно быть не менее 3 символов";
			RepairOrderGet = обПолучитьВозвратWAError("http://wa.dms.webservice/RepairOrderGetRequest",RepairOrderGetRequest,RepairOrderGet,"-1",ТаблицаОщибок);
			Возврат RepairOrderGet;      
		КонецЕсли;
	Исключение
		ФамилияКонтрагента = "";
	КонецПопытки;
	Попытка
		КодАвтомобиля = RepairOrderGetRequest.RepairOrderGet.VehicleGet.DMSVehicleNo;
	Исключение
		КодАвтомобиля = "";
	КонецПопытки;   
	Попытка
		VINАвтомобиля = RepairOrderGetRequest.RepairOrderGet.VehicleGet.VIN;
		Если ЗначениеЗаполнено(VINАвтомобиля) И СтрДлина(VINАвтомобиля) <> 17 Тогда
			НоваяСтрока = ТаблицаОщибок.Добавить();
			НоваяСтрока.Код = "ROG03";
			НоваяСтрока.ТекстОшибки = "VIN должен состоять из 17 символов";
			RepairOrderGet = обПолучитьВозвратWAError("http://wa.dms.webservice/RepairOrderGetRequest",RepairOrderGetRequest,RepairOrderGet,"-1",ТаблицаОщибок);
			Возврат RepairOrderGet;      
		КонецЕсли;
	Исключение
		VINАвтомобиля = "";
	КонецПопытки;   
    Попытка
		ФрагментVINАвтомобиля = RepairOrderGetRequest.RepairOrderGet.VehicleGet.LastSixVIN;
		Если ЗначениеЗаполнено(ФрагментVINАвтомобиля) И СтрДлина(ФрагментVINАвтомобиля) < 6 Тогда
			НоваяСтрока = ТаблицаОщибок.Добавить();
			НоваяСтрока.Код = "ROG04";
			НоваяСтрока.ТекстОшибки = "Фрагмент VIN для поиска должен быть не менее 6 символов";
			RepairOrderGet = обПолучитьВозвратWAError("http://wa.dms.webservice/RepairOrderGetRequest",RepairOrderGetRequest,RepairOrderGet,"-1",ТаблицаОщибок);
			Возврат RepairOrderGet;      
		КонецЕсли;
	Исключение
		ФрагментVINАвтомобиля = "";
	КонецПопытки;
	
    Запрос = Новый Запрос;
	
	// БЛОК КЛЮЧЕВОГО ПОИСКА
	СтрокаКлючевогоПоиска = "";	
	Если ЗначениеЗаполнено(IDЗаказНаряда) Тогда
		ID = Новый УникальныйИдентификатор(IDЗаказНаряда);
		ЗаказНарядСсылка = Документы.ЗаказНаряд.ПолучитьСсылку(ID);
    	Если ЗаказНарядСсылка.ПолучитьОбъект() = Неопределено Тогда		
			НоваяСтрока = ТаблицаОщибок.Добавить();
			НоваяСтрока.Код = "WA03";
			НоваяСтрока.ТекстОшибки = "Заказ-наряд с указанным идентификатором не найден";
			RepairOrderGet = обПолучитьВозвратWAError("http://wa.dms.webservice/RepairOrderGetRequest",RepairOrderGetRequest,RepairOrderGet,"-1",ТаблицаОщибок);
			Возврат RepairOrderGet;  		
		КонецЕсли;
	Иначе
		ЗаказНарядСсылка = Документы.ЗаказНаряд.ПустаяСсылка();
	КонецЕсли;	
	Если ЗначениеЗаполнено(ЗаказНарядСсылка) Тогда
		СтрокаКлючевогоПоиска = "И ЗаказНаряд.Ссылка = &ЗаказНарядСсылка";
		Запрос.Параметры.Вставить("ЗаказНарядСсылка", ЗаказНарядСсылка);
	ИначеЕсли ЗначениеЗаполнено(НомерЗаказНаряда) Тогда
		СтрокаКлючевогоПоиска = "И ЗаказНаряд.Номер = &НомерЗаказНаряда";
		Запрос.Параметры.Вставить("НомерЗаказНаряда", НомерЗаказНаряда);
	КонецЕсли;   

	Запрос.Текст = "ВЫБРАТЬ
	               |	ЗаказНаряд.Ссылка,
	               |	ЗаказНаряд.Номер,
	               |	ЗаказНаряд.Дата КАК Дата,
	               |	ЗаказНаряд.ДокументОснование,
	               |	ЗаказНаряд.ВидРемонта,
				   |	ЗаказНаряд.Состояние,
	               |	ЗаказНаряд.Заказчик,
	               |	ЗаказНаряд.Автомобиль,
	               |	ЗаказНаряд.Контрагент,
	               |	ЗаказНаряд.Диспетчер,
	               |	ЗаказНаряд.ДатаСоздания,
	               |	ЗаказНаряд.ДатаОкончания,
	               |	ЗаказНаряд.ПлановаяДатаВыдачи,
	               |	ЗаказНаряд.ПричинаОбращения,
	               |	ЗаказНаряд.МаркетинговаяПрограмма.Наименование КАК МаркетинговаяПрограмма,
	               |	ЗаказНаряд.Цех,
	               |	ЗаказНаряд.ВидОплаты
	               |ИЗ
	               |	Документ.ЗаказНаряд КАК ЗаказНаряд
	               |ГДЕ
				   |	ЗаказНаряд.Автомобиль.Модель.Марка = &Hyundai
				   |	И ЗаказНаряд.ВидРемонта.SendWA = ИСТИНА
                   |	" + СтрокаКлючевогоПоиска + "
                   |	"+?(ЗаданДиапазонДатСоздания,"И ЗаказНаряд.ДатаСоздания МЕЖДУ &ДатаНач И &ДатаКон","")+"
				   |	"+?(ЗначениеЗаполнено(НомерЗаявкиНаРемонт),"И ЗаказНаряд.ДокументОснование.Номер = &НомерЗаявкиНаРемонт","")+"
                   |	"+?(ЗначениеЗаполнено(СостояниеЗаказНаряда),"И ЗаказНаряд.Состояние = &СостояниеЗаказНаряда","")+"
	               |	"+?(ЗначениеЗаполнено(КодМастера),"И ЗаказНаряд.Диспетчер.Код = &КодМастера","")+"
	               |	"+?(ЗначениеЗаполнено(НаименованиеМастера),"И ЗаказНаряд.Диспетчер.Наименование = &НаименованиеМастера","")+"
                   |	"+?(ЗначениеЗаполнено(КодКонтрагента),"И ЗаказНаряд.Заказчик.Код = &КодЗаказчика","")+"
                   |	"+?(ЗначениеЗаполнено(ФамилияКонтрагента),"И ЗаказНаряд.Заказчик.Наименование ПОДОБНО &ФамилияКонтрагента","")+"
                   |	"+?(ЗначениеЗаполнено(КодАвтомобиля),"И ЗаказНаряд.Автомобиль.Код = &КодАвтомобиля","")+"
                   |	"+?(ЗначениеЗаполнено(VINАвтомобиля),"И ЗаказНаряд.Автомобиль.VIN = &VIN","")+"
                   |	"+?(ЗначениеЗаполнено(ФрагментVINАвтомобиля),"И ЗаказНаряд.Автомобиль.VIN ПОДОБНО &ФрагментVINАвтомобиля","")+"
	               |	
				   |УПОРЯДОЧИТЬ ПО
	               |	ДатаСоздания УБЫВ
				   |ИТОГИ
				   |	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Ссылка)
				   |ПО
				   |	ДокументОснование";
				   				   
	Запрос.Параметры.Вставить("Hyundai", Справочники.Марка.HYUNDAI);
	Если ЗаданДиапазонДатСоздания Тогда
		Запрос.Параметры.Вставить("ДатаНач", НачДатаЗаказНаряда);
		Запрос.Параметры.Вставить("ДатаКон", КонДатаЗаказНаряда);
	КонецЕсли;   
	Если ЗначениеЗаполнено(НомерЗаявкиНаРемонт) Тогда
		Запрос.Параметры.Вставить("НомерЗаявкиНаРемонт",НомерЗаявкиНаРемонт);
	КонецЕсли;  
	Если ЗначениеЗаполнено(СостояниеЗаказНаряда) Тогда
		Если СостояниеЗаказНаряда = "1" Тогда
			Состояние = Справочники.ВидыСостоянийЗаказНарядов.Заявка;	
		ИначеЕсли СостояниеЗаказНаряда = "2" Тогда
			Состояние = Справочники.ВидыСостоянийЗаказНарядов.ВРаботе;
		ИначеЕсли СостояниеЗаказНаряда = "3" Тогда
			Состояние = Справочники.ВидыСостоянийЗаказНарядов.Согласование;
		ИначеЕсли СостояниеЗаказНаряда = "4" Тогда
			Состояние = Справочники.ВидыСостоянийЗаказНарядов.Ожидание;
		ИначеЕсли СостояниеЗаказНаряда = "5" Тогда
			Состояние = Справочники.ВидыСостоянийЗаказНарядов.Стоянка;
		ИначеЕсли СостояниеЗаказНаряда = "6" Тогда
			Состояние = Справочники.ВидыСостоянийЗаказНарядов.Выполнен;
		ИначеЕсли СостояниеЗаказНаряда = "7" Тогда
			Состояние = Справочники.ВидыСостоянийЗаказНарядов.Закрыт;
		ИначеЕсли СостояниеЗаказНаряда = "8" Тогда
			Состояние = Справочники.ВидыСостоянийЗаказНарядов.ВРезерве;
		ИначеЕсли СостояниеЗаказНаряда = "9" Тогда
			Состояние = Справочники.ВидыСостоянийЗаказНарядов.Отказ;
        КонецЕсли;
		Запрос.Параметры.Вставить("СостояниеЗаказНаряда",Состояние);
	КонецЕсли; 
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
		Запрос.Параметры.Вставить("ФамилияКонтрагента", "%" + ФамилияКонтрагента + "%");
	КонецЕсли;
    Если ЗначениеЗаполнено(КодАвтомобиля) Тогда
		Запрос.Параметры.Вставить("КодАвтомобиля",КодАвтомобиля);
	КонецЕсли;
    Если ЗначениеЗаполнено(VINАвтомобиля) Тогда
		Запрос.Параметры.Вставить("VIN", VINАвтомобиля);
	КонецЕсли;
    Если ЗначениеЗаполнено(ФрагментVINАвтомобиля) Тогда
		Запрос.Параметры.Вставить("ФрагментVINАвтомобиля", "%" + ФрагментVINАвтомобиля + "%");
	КонецЕсли;     
	
	ВыборкаПервая = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);

    Если ВыборкаПервая.Количество() = 0 Тогда                         		
		RepairOrderGet = обПолучитьВозвратWAError("http://wa.dms.webservice/RepairOrderGetRequest",RepairOrderGetRequest,RepairOrderGet,"0",ТаблицаОщибок);
		Возврат RepairOrderGet;  		
	Иначе
		RepairOrderDocumentsType = ФабрикаXDTO.Тип("http://wa.dms.webservice/RepairOrderGetRequest", "ArrayOfRepairOrderDocument");
		RepairOrderDocuments = ФабрикаXDTO.Создать(RepairOrderDocumentsType); 	
		Пока ВыборкаПервая.Следующий() Цикл
			RepairOrderDocumentType = ФабрикаXDTO.Тип("http://wa.dms.webservice/RepairOrderGetRequest", "RepairOrderDocument");
			RepairOrderDocument = ФабрикаXDTO.Создать(RepairOrderDocumentType);
			Если ЗначениеЗаполнено(ВыборкаПервая.ДокументОснование) И ТипЗнч(ВыборкаПервая.ДокументОснование) = Тип("ДокументСсылка.ЗаявкаНаРемонт") Тогда
				RepairOrderDocument.DMSRODocumentNo = ВыборкаПервая.ДокументОснование.Номер;
				RepairOrderDocument.DMSRODocumentStatus = "1";
			Иначе
				RepairOrderDocument.DMSRODocumentNo = "";
				RepairOrderDocument.DMSRODocumentStatus = "";
			КонецЕсли;
			
			RepairOrdersType = ФабрикаXDTO.Тип("http://wa.dms.webservice/RepairOrderGetRequest", "ArrayOfRepairOrder");
			RepairOrders = ФабрикаXDTO.Создать(RepairOrdersType); 			
			Выборка = ВыборкаПервая.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			Пока Выборка.Следующий() Цикл 	
				Если ЗначениеЗаполнено(ФамилияКонтрагента) Тогда
					Фамилия = обПолучитьФамилия(Выборка.Заказчик.Наименование);
					Если нрег(Фамилия)<>нрег(ФамилияКонтрагента) Тогда
						продолжить;
					КонецЕсли;
				КонецЕсли;
				RepairOrderType = ФабрикаXDTO.Тип("http://wa.dms.webservice/RepairOrderGetRequest", "RepairOrder");
				RepairOrder = ФабрикаXDTO.Создать(RepairOrderType);
	            RepairOrder.DMSRONo = Выборка.Номер;
				RepairOrder.DMSROID = Строка(Выборка.Ссылка.УникальныйИдентификатор());
	            RepairOrder.DeliveryDateTimeLocal = Выборка.ПлановаяДатаВыдачи;   
				RepairOrder.OpenDateTimeLocal = Выборка.ДатаСоздания;
	            RepairOrder.CloseDateTimeLocal = Выборка.ДатаОкончания;
				Если Выборка.Состояние = Справочники.ВидыСостоянийЗаказНарядов.Заявка Тогда
					Состояние =  "1";	
				ИначеЕсли Выборка.Состояние = Справочники.ВидыСостоянийЗаказНарядов.ВРаботе Тогда
					Состояние = "2";
				ИначеЕсли Выборка.Состояние = Справочники.ВидыСостоянийЗаказНарядов.Согласование Тогда
					Состояние = "3";
				ИначеЕсли Выборка.Состояние = Справочники.ВидыСостоянийЗаказНарядов.Ожидание Тогда
					Состояние = "4";
				ИначеЕсли Выборка.Состояние = Справочники.ВидыСостоянийЗаказНарядов.Стоянка Тогда
					Состояние = "5";
				ИначеЕсли Выборка.Состояние = Справочники.ВидыСостоянийЗаказНарядов.Выполнен Тогда
					Состояние = "6";
				ИначеЕсли Выборка.Состояние = Справочники.ВидыСостоянийЗаказНарядов.Закрыт Тогда
					Состояние = "7";
				ИначеЕсли Выборка.Состояние = Справочники.ВидыСостоянийЗаказНарядов.ВРезерве Тогда
					Состояние = "8";
				ИначеЕсли Выборка.Состояние = Справочники.ВидыСостоянийЗаказНарядов.Отказ Тогда
					Состояние = "9";
		        КонецЕсли;     
				RepairOrder.DMSROStatus = Состояние;
				Если Выборка.Цех = Справочники.Цеха.ОсновнойЦех Тогда
					RepairOrder.WorkType = "2";          	
				Иначе
					RepairOrder.WorkType = "1";    
				КонецЕсли;
				КраткоеОбозначение = Выборка.ВидРемонта.КраткоеОбозначение;
	            RepairOrder.ServiceType	= КраткоеОбозначение;      			
				Если Выборка.ВидОплаты = Перечисления.ВидыОплаты.НаличныйРасчет Тогда
					RepairOrder.PaymentMethod = "1";
				ИначеЕсли Выборка.ВидОплаты = Перечисления.ВидыОплаты.БанковскаяКарта Тогда
	            	RepairOrder.PaymentMethod = "3";
	            ИначеЕсли Выборка.ВидОплаты = Перечисления.ВидыОплаты.БезналичныйРасчет Тогда
	            	RepairOrder.PaymentMethod = "2";
				Иначе
					RepairOrder.PaymentMethod = "1";
				КонецЕсли;  			

				ПробегНаКонец = Справочники.Автомобили.ЧтениеЗначенияРегистраСведения(Выборка.Автомобиль, Перечисления.ДополнительнаяИнформацияАвтомобилей.Пробег, 
											?(обЗначениеНеЗаполнено(Выборка.ДатаОкончания), Выборка.ДатаСоздания, Выборка.ДатаОкончания));
				Если обЗначениеНеЗаполнено(ПробегНаКонец) Тогда
					RepairOrder.OutMileage = ""; 
				Иначе
					RepairOrder.OutMileage = Формат(ПробегНаКонец,"ЧЦ=7; ЧДЦ=0; ЧГ=0");  	
				КонецЕсли;
				
				ПробегНаНачало = Выборка.Ссылка.Пробег;
				Если обЗначениеНеЗаполнено(ПробегНаНачало) Тогда
					ПробегНаНачало = Справочники.Автомобили.ЧтениеЗначенияРегистраСведения(Выборка.Автомобиль, Перечисления.ДополнительнаяИнформацияАвтомобилей.Пробег, 
												Выборка.ДатаСоздания);
				КонецЕсли;											
				Если обЗначениеНеЗаполнено(ПробегНаНачало) Тогда
					RepairOrder.InMileage = ""; 
				Иначе
					RepairOrder.InMileage = Формат(ПробегНаНачало,"ЧЦ=7; ЧДЦ=0; ЧГ=0");  	
				КонецЕсли; 
				
				RepairOrder.HangTagNo = "";
				RepairOrder.HangTagColor = "";  
				RepairOrder.ROChannel = "1";
				RepairOrder.SAEmployeeID = Выборка.Диспетчер.Код;
				RepairOrder.SAEmployeeName = Выборка.Диспетчер.Наименование;  
	            RepairOrder.TCEmployeeID = "";
				RepairOrder.TCEmployeeName = "";
				RepairOrder.Description = Выборка.ПричинаОбращения;
				Если ЗначениеЗаполнено(Выборка.МаркетинговаяПрограмма) Тогда
					RepairOrder.DiscountDescription = Выборка.МаркетинговаяПрограмма;
				Иначе
					RepairOrder.DiscountDescription = "";					
				КонецЕсли;
				
				//ПерваяЗапись = РегистрыСведений.Версионирование.ПолучитьПервое(,Новый Структура("Идентификатор, ПредставлениеМетаданных",Выборка.Ссылка.УникальныйИдентификатор(),Выборка.Ссылка.Метаданные().ПолноеИмя()));
				//ПоследняяЗапись = РегистрыСведений.Версионирование.ПолучитьПоследнее(,Новый Структура("Идентификатор, ПредставлениеМетаданных",Выборка.Ссылка.УникальныйИдентификатор(),Выборка.Ссылка.Метаданные().ПолноеИмя()));
				ПерваяЗапись = ТекущаяДата();
				ПоследняяЗапись = ТекущаяДата();

				ManagementFieldsDataType = ФабрикаXDTO.Тип("http://wa.dms.webservice/RepairOrderGetRequest", "ManagementFields");
				ManagementFieldsData = ФабрикаXDTO.Создать(ManagementFieldsDataType); 
				ManagementFieldsData.CreateDateTimeUTC = ПерваяЗапись;
				ManagementFieldsData.LastModifiedDateTimeUTC = ПоследняяЗапись;
				RepairOrder.ManagementFields = ManagementFieldsData;
				
				JobRefsType = ФабрикаXDTO.Тип("http://wa.dms.webservice/RepairOrderGetRequest", "ArrayOfJobRef");
				JobRefs = ФабрикаXDTO.Создать(JobRefsType); 
	            RepairOrder.JobRefs = JobRefs;
				
				AppointmentRefType = ФабрикаXDTO.Тип("http://wa.dms.webservice/RepairOrderGetRequest", "AppointmentRef");
				AppointmentRef = ФабрикаXDTO.Создать(AppointmentRefType); 
				Если ЗначениеЗаполнено(Выборка.ДокументОснование) И ТипЗнч(Выборка.ДокументОснование)=Тип("ДокументСсылка.ЗаявкаНаРемонт") Тогда
					ДатаЗаписи = ?(Выборка.ДокументОснование.ХозОперация=Справочники.ХозОперации.ЗаявкаНаРемонт,НачалоДня(Выборка.ДокументОснование.Дата),НачалоДня(Выборка.ДокументОснование.ДатаНачала));
					Если ДатаЗаписи < НачалоДня(ТекущаяДата()) Тогда
						ЗапросЗаявкиНаТекДень = Новый Запрос;
						ЗапросЗаявкиНаТекДень.Текст = "ВЫБРАТЬ
													  |	ЗаявкаНаРемонт.Ссылка
													  |ИЗ
													  |	Документ.ЗаявкаНаРемонт КАК ЗаявкаНаРемонт
													  |ГДЕ
													  |	ЗаявкаНаРемонт.ХозОперация = &ПланРемонта
													  |	И ЗаявкаНаРемонт.Проведен = ИСТИНА
													  |	И ЗаявкаНаРемонт.ДатаНачала МЕЖДУ &НачИнтервала И &КонИнтервала
													  |	И ЗаявкаНаРемонт.Заказчик = &Заказчик
													  |	И ЗаявкаНаРемонт.Автомобиль = &Авто";
													  
						ЗапросЗаявкиНаТекДень.Параметры.Вставить("ПланРемонта", Справочники.ХозОперации.ПланРемонта);
						ЗапросЗаявкиНаТекДень.Параметры.Вставить("НачИнтервала", НачалоДня(ТекущаяДата()));
						ЗапросЗаявкиНаТекДень.Параметры.Вставить("КонИнтервала", КонецДня(ТекущаяДата()));
						ЗапросЗаявкиНаТекДень.Параметры.Вставить("Заказчик", Выборка.Заказчик);
						ЗапросЗаявкиНаТекДень.Параметры.Вставить("Авто", Выборка.Автомобиль);
                        ВыборкаЗаявкиНаТекДень = ЗапросЗаявкиНаТекДень.Выполнить().Выбрать();
						Если ВыборкаЗаявкиНаТекДень.Количество()=0 Тогда
							AppointmentRef.DMSAppointmentID = Строка(Выборка.ДокументОснование.Ссылка.УникальныйИдентификатор());
							AppointmentRef.DMSAppointmentNo = Выборка.ДокументОснование.Номер;
							AppointmentRef.DMSAppointmentStatus = "1";  
						Иначе
							ВыборкаЗаявкиНаТекДень.Следующий();
							AppointmentRef.DMSAppointmentID = Строка(ВыборкаЗаявкиНаТекДень.Ссылка.УникальныйИдентификатор());
							AppointmentRef.DMSAppointmentNo = ВыборкаЗаявкиНаТекДень.Ссылка.Номер;
							AppointmentRef.DMSAppointmentStatus = "1";  
						КонецЕсли;						
					Иначе
						AppointmentRef.DMSAppointmentID = Строка(Выборка.ДокументОснование.Ссылка.УникальныйИдентификатор());
						AppointmentRef.DMSAppointmentNo = Выборка.ДокументОснование.Номер;
						AppointmentRef.DMSAppointmentStatus = "1";   
					КонецЕсли;
				Иначе
					ЗапросЗаявкиНаТекДень = Новый Запрос;
					ЗапросЗаявкиНаТекДень.Текст = "ВЫБРАТЬ
												  |	ЗаявкаНаРемонт.Ссылка
												  |ИЗ
												  |	Документ.ЗаявкаНаРемонт КАК ЗаявкаНаРемонт
												  |ГДЕ
												  |	ЗаявкаНаРемонт.Проведен = ИСТИНА
												  |	И ЗаявкаНаРемонт.ДатаНачала МЕЖДУ &НачИнтервала И &КонИнтервала
												  |	И ЗаявкаНаРемонт.Заказчик = &Заказчик
												  |	И ЗаявкаНаРемонт.Автомобиль = &Авто";
												  
					//ЗапросЗаявкиНаТекДень.Параметры.Вставить("ПланРемонта", Справочники.ХозОперации.ПланРемонта);
					ЗапросЗаявкиНаТекДень.Параметры.Вставить("НачИнтервала", НачалоДня(ТекущаяДата()));
					ЗапросЗаявкиНаТекДень.Параметры.Вставить("КонИнтервала", КонецДня(ТекущаяДата()));
					ЗапросЗаявкиНаТекДень.Параметры.Вставить("Заказчик", Выборка.Заказчик);
					ЗапросЗаявкиНаТекДень.Параметры.Вставить("Авто", Выборка.Автомобиль);
                    ВыборкаЗаявкиНаТекДень = ЗапросЗаявкиНаТекДень.Выполнить().Выбрать();
					Если ВыборкаЗаявкиНаТекДень.Количество()=0 Тогда
						//AppointmentRef.DMSAppointmentID = Строка(Выборка.ДокументОснование.Ссылка.УникальныйИдентификатор());
						//AppointmentRef.DMSAppointmentNo = Выборка.ДокументОснование.Номер;
						//AppointmentRef.DMSAppointmentStatus = "1";  
					Иначе
						ВыборкаЗаявкиНаТекДень.Следующий();
						AppointmentRef.DMSAppointmentID = Строка(ВыборкаЗаявкиНаТекДень.Ссылка.УникальныйИдентификатор());
						AppointmentRef.DMSAppointmentNo = ВыборкаЗаявкиНаТекДень.Ссылка.Номер;
						AppointmentRef.DMSAppointmentStatus = "1";  
					КонецЕсли;						
				КонецЕсли;
				RepairOrder.AppointmentRef = AppointmentRef;
				
				AdditionalFieldsType = ФабрикаXDTO.Тип("http://wa.dms.webservice/RepairOrderGetRequest", "ArrayOfAdditionalField");
				AdditionalFields = ФабрикаXDTO.Создать(AdditionalFieldsType);
				AdditionalFieldType = ФабрикаXDTO.Тип("http://wa.dms.webservice/RepairOrderGetRequest", "AdditionalField");
				AdditionalField = ФабрикаXDTO.Создать(AdditionalFieldType); 
				AdditionalField.AdditionalFieldName = "PartsCampaignDiscountAmount";
                AdditionalField.AdditionalFieldValue = Формат(Выборка.Ссылка.Товары.Итог("СуммаСкидки")+Выборка.Ссылка.Товары.Итог("СуммаСкидкиСтроки"),"ЧЦ=15; ЧДЦ=2; ЧРД=.; ЧГ=0");
                AdditionalFields.AdditionalField.Добавить(AdditionalField);
				AdditionalField = ФабрикаXDTO.Создать(AdditionalFieldType); 
				AdditionalField.AdditionalFieldName = "LaborCampaignDiscountAmount";
                AdditionalField.AdditionalFieldValue = Формат(Выборка.Ссылка.Работы.Итог("СуммаСкидки")+Выборка.Ссылка.Работы.Итог("СуммаСкидкиСтроки"),"ЧЦ=15; ЧДЦ=2; ЧРД=.; ЧГ=0");
                AdditionalFields.AdditionalField.Добавить(AdditionalField);
				AdditionalField = ФабрикаXDTO.Создать(AdditionalFieldType); 
				AdditionalField.AdditionalFieldName = "TotalCampaignDiscountAmount";
                AdditionalField.AdditionalFieldValue = Формат(Выборка.Ссылка.Товары.Итог("СуммаСкидки")+Выборка.Ссылка.Товары.Итог("СуммаСкидкиСтроки")+Выборка.Ссылка.Работы.Итог("СуммаСкидки")+Выборка.Ссылка.Работы.Итог("СуммаСкидкиСтроки"),"ЧЦ=15; ЧДЦ=2; ЧРД=.; ЧГ=0");
                AdditionalFields.AdditionalField.Добавить(AdditionalField);
				AdditionalField = ФабрикаXDTO.Создать(AdditionalFieldType); 
				AdditionalField.AdditionalFieldName = "TotalAmount";
                AdditionalField.AdditionalFieldValue = Формат(Выборка.Ссылка.СуммаДокумента,"ЧЦ=15; ЧДЦ=2; ЧРД=.; ЧГ=0");
                AdditionalFields.AdditionalField.Добавить(AdditionalField);
				AdditionalField = ФабрикаXDTO.Создать(AdditionalFieldType); 
				AdditionalField.AdditionalFieldName = "VATAmount";
                AdditionalField.AdditionalFieldValue = Формат(Выборка.Ссылка.Товары.Итог("СуммаНДС"),"ЧЦ=15; ЧДЦ=2; ЧРД=.; ЧГ=0");
                AdditionalFields.AdditionalField.Добавить(AdditionalField);
								
				OptionsType = ФабрикаXDTO.Тип("http://wa.dms.webservice/RepairOrderGetRequest", "ArrayOfOption");
				Options = ФабрикаXDTO.Создать(OptionsType); 
				OptionType = ФабрикаXDTO.Тип("http://wa.dms.webservice/RepairOrderGetRequest", "Option");
				
				Option = ФабрикаXDTO.Создать(OptionType); 
				Option.OptionName = "PersonalInfoAgreeYN";
	   			СогласенДо = Выборка.Заказчик._г_ДатаОкончанияСогласия; 
				Option.OptionValue = ?(Выборка.Заказчик.СогласиеНаОбработкуПерсональныхДанных=Перечисления.ВариантыОтветов.Да И СогласенДо>ТекущаяДата(),"Y","N");
				Options.Option.Добавить(Option);
				
				Option = ФабрикаXDTO.Создать(OptionType); 
				Option.OptionName = "WaitYN";
				Если ЗначениеЗаполнено(Выборка.Ссылка.Ожидает) Тогда				
					Option.OptionValue = ?(Выборка.Ссылка.Ожидает = Перечисления.Ожидание.ВСалоне, "Y", "N");
				Иначе
					Option.OptionValue = "N";					
				КонецЕсли;
				Options.Option.Добавить(Option);

				Option = ФабрикаXDTO.Создать(OptionType); 
				Option.OptionName = "AgreeToCallYN";
				Если ЗначениеЗаполнено(Выборка.Ссылка.Согласование) Тогда	
					Option.OptionValue = ?(Выборка.Ссылка.Согласование = Перечисления.Согласование.ПоТелефону, "Y", "N");
				Иначе
					Option.OptionValue = "N";
				КонецЕсли;	
				Options.Option.Добавить(Option);
				
				Option = ФабрикаXDTO.Создать(OptionType); 
				Option.OptionName = "SaveReplacePartYN";
				Если ЗначениеЗаполнено(Выборка.Ссылка.ДемонтированныеЗапчасти) Тогда	
					Option.OptionValue = ?(Выборка.Ссылка.ДемонтированныеЗапчасти = Перечисления.ДемонтированныеЗапчасти.Сохранить, "Y", "N");
				Иначе
					Option.OptionValue = "N";
				КонецЕсли;
				Options.Option.Добавить(Option);
				
				RepairOrder.Options = Options;

	            PriceType = ФабрикаXDTO.Тип("http://wa.dms.webservice/RepairOrderGetRequest", "PriceType");
				Price = ФабрикаXDTO.Создать(PriceType); 
				Price.UnitPrice = Формат(Выборка.Ссылка.Товары.Итог("Сумма")+Выборка.Ссылка.Работы.Итог("Сумма"),"ЧЦ=15; ЧДЦ=2; ЧРД=.; ЧГ=0");
				Price.TotalPrice = Формат(Выборка.Ссылка.Товары.Итог("СуммаВсего")+Выборка.Ссылка.Работы.Итог("СуммаВсего"),"ЧЦ=15; ЧДЦ=2; ЧРД=.; ЧГ=0");
				Price.TotalPriceIncludeTax = Формат(Выборка.Ссылка.Товары.Итог("СуммаВсего")+Выборка.Ссылка.Работы.Итог("СуммаВсего"),"ЧЦ=15; ЧДЦ=2; ЧРД=.; ЧГ=0");
				Price.DiscountRate = "";
				Price.DiscountPrice = Формат(Выборка.Ссылка.СуммаСкидкиНаценки+Выборка.Ссылка.СуммаСкидкиНаценкиРабот,"ЧЦ=15; ЧДЦ=2; ЧРД=.; ЧГ=0");
				RepairOrder.PriceType = Price;
				           			
				CustomerPartsType = ФабрикаXDTO.Тип("http://wa.dms.webservice/RepairOrderGetRequest", "ArrayOfCustomerPart");
				CustomerParts = ФабрикаXDTO.Создать(CustomerPartsType); 			
				Для Каждого Номенклатура Из Выборка.Ссылка.МатериалыЗаказчика Цикл
					CustomerPartType = ФабрикаXDTO.Тип("http://wa.dms.webservice/RepairOrderGetRequest", "CustomerPart");
					CustomerPart = ФабрикаXDTO.Создать(CustomerPartType); 
					CustomerPart.PartNumber = Номенклатура.Номенклатура.Артикул;
					CustomerPart.PartDescription = Номенклатура.Номенклатура.Наименование;
					CustomerPart.Quantity = Формат(Номенклатура.Количество,"ЧЦ=15; ЧДЦ=2; ЧРД=.; ЧГ=0");
					CustomerPart.UnitOfMeasure = Номенклатура.ЕдиницаИзмерения.Наименование; 
					CustomerPart.Comment = "";
					CustomerParts.CustomerPart.Добавить(CustomerPart);
				КонецЦикла;
				RepairOrder.CustomerParts = CustomerParts; 			

	   			CustomersType = ФабрикаXDTO.Тип("http://wa.dms.webservice/RepairOrderGetRequest", "ArrayOfCustomer");
				Customers = ФабрикаXDTO.Создать(CustomersType); 
				
				// ЗАКАЗЧИК 	
				CustomerType = ФабрикаXDTO.Тип("http://wa.dms.webservice/RepairOrderGetRequest", "Customer");
				CustomerData = ФабрикаXDTO.Создать(CustomerType); 
				CustomerData = обGetCustomer("http://wa.dms.webservice/RepairOrderGetRequest", CustomerData, Выборка.Заказчик, "2");		        
				Customers.Customer.Добавить(CustomerData);
				
				// ВЛАДЕЛЕЦ 	
				Если НЕ Выборка.Контрагент=Справочники.Контрагенты.ОсновнойПокупатель Тогда
					CustomerType = ФабрикаXDTO.Тип("http://wa.dms.webservice/RepairOrderGetRequest", "Customer");
					CustomerData = ФабрикаXDTO.Создать(CustomerType);                     			
					CustomerData = обGetCustomer("http://wa.dms.webservice/RepairOrderGetRequest", CustomerData, Выборка.Контрагент, "1");
					Customers.Customer.Добавить(CustomerData);
				КонецЕсли; 				
				RepairOrder.Customers = Customers;

	            // АВТОМОБИЛЬ
				VehicleType = ФабрикаXDTO.Тип("http://wa.dms.webservice/RepairOrderGetRequest", "Vehicle");
				VehicleData = ФабрикаXDTO.Создать(VehicleType);
				VehicleData = обGetVehicle("http://wa.dms.webservice/RepairOrderGetRequest", VehicleData, Выборка.Автомобиль);		        
				RepairOrder.Vehicle = VehicleData;

	            RequestItemsType = ФабрикаXDTO.Тип("http://wa.dms.webservice/RepairOrderGetRequest", "ArrayOfRequestItem");
				RequestItems = ФабрикаXDTO.Создать(RequestItemsType);
				// РАБОТЫ
				СуммаДоп = 0;				
				RequestItemType = ФабрикаXDTO.Тип("http://wa.dms.webservice/RepairOrderGetRequest", "RequestItem");
				RequestItemJobs = ФабрикаXDTO.Создать(RequestItemType); 
	            RequestItemJobs.ServiceLineNumber = "1";
				RequestItemJobs.ServiceLineStatus = "";
				RequestItemJobs.RequestCode = "Request_OP";
				RequestItemJobs.RequestDescription = "";
				RequestItemJobs.CPSIND = "";
				RequestItemJobs.WorkType = "1";    		
				RequestItemJobs.ServiceType	= КраткоеОбозначение;
	            RequestItemJobs.TCEmployeeID = "";
				RequestItemJobs.TCEmployeeName = "";   
				CommentsType = ФабрикаXDTO.Тип("http://wa.dms.webservice/RepairOrderGetRequest", "ArrayOfComment");
				Comments = ФабрикаXDTO.Создать(CommentsType);
				RequestItemJobs.Comments = Comments;  			
				DescriptionsType = ФабрикаXDTO.Тип("http://wa.dms.webservice/RepairOrderGetRequest", "ArrayOfDescription");
				Descriptions = ФабрикаXDTO.Создать(DescriptionsType);
				RequestItemJobs.Descriptions = Descriptions;
				
				OPCodesType = ФабрикаXDTO.Тип("http://wa.dms.webservice/RepairOrderGetRequest", "ArrayOfOPCode");
				OPCodes = ФабрикаXDTO.Создать(OPCodesType);			
				Если КраткоеОбозначение = "10" Тогда
					КодПакетаТО = ПолучитьКодПакетаТО(Выборка.Автомобиль, Выборка.Ссылка.НомерТО);
				Иначе
					КодПакетаТО = "";
				КонецЕсли;
				
				OPCodeType = ФабрикаXDTO.Тип("http://wa.dms.webservice/RepairOrderGetRequest", "OPCode");
				Для Каждого Работа Из Выборка.Ссылка.Работы Цикл
					Если НЕ Работа.Основная Тогда
						СуммаДоп = СуммаДоп + Работа.СуммаВсего;	
					КонецЕсли;
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
					PriceType = ФабрикаXDTO.Тип("http://wa.dms.webservice/RepairOrderGetRequest", "PriceType");
					Price = ФабрикаXDTO.Создать(PriceType); 
					Price.UnitPrice = Формат(Работа.Цена*Работа.Коэффициент,"ЧЦ=15; ЧДЦ=2; ЧРД=.; ЧГ=0");
					Price.TotalPrice = Формат(Работа.СуммаВсего,"ЧЦ=15; ЧДЦ=2; ЧРД=.; ЧГ=0");
					Price.TotalPriceIncludeTax = Формат(Работа.СуммаВсего,"ЧЦ=15; ЧДЦ=2; ЧРД=.; ЧГ=0");
					Price.DiscountRate = Формат(?(обЗначениеНеЗаполнено(Работа.ПроцентСкидки),Работа.ПроцентСкидкиСтроки,Работа.ПроцентСкидки),"ЧЦ=15; ЧДЦ=2; ЧРД=.; ЧГ=0");
					Price.DiscountPrice = Формат(Работа.СуммаСкидки+Работа.СуммаСкидкиСтроки,"ЧЦ=15; ЧДЦ=2; ЧРД=.; ЧГ=0");
					OPCode.PriceType = Price;  
					DescriptionsType = ФабрикаXDTO.Тип("http://wa.dms.webservice/RepairOrderGetRequest", "ArrayOfDescription");
					Descriptions = ФабрикаXDTO.Создать(DescriptionsType);
					OPCode.Descriptions = Descriptions;   				
					CausesType = ФабрикаXDTO.Тип("http://wa.dms.webservice/RepairOrderGetRequest", "ArrayOfCause");
					Causes = ФабрикаXDTO.Создать(CausesType);
					OPCode.Causes = Causes;   				
					CorrectionsType = ФабрикаXDTO.Тип("http://wa.dms.webservice/RepairOrderGetRequest", "ArrayOfCorrection");
					Corrections = ФабрикаXDTO.Создать(CorrectionsType);
					OPCode.Corrections = Corrections;  				
					PartsType = ФабрикаXDTO.Тип("http://wa.dms.webservice/RepairOrderGetRequest", "ArrayOfPart");
					Parts = ФабрикаXDTO.Создать(PartsType);
					OPCode.Parts = Parts;  				
					SubletsType = ФабрикаXDTO.Тип("http://wa.dms.webservice/RepairOrderGetRequest", "ArrayOfSublet");
					Sublets = ФабрикаXDTO.Создать(SubletsType);
					OPCode.Sublets = Sublets;  				
					MISCsType = ФабрикаXDTO.Тип("http://wa.dms.webservice/RepairOrderGetRequest", "ArrayOfMISC");
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
	            Если Выборка.Цех = Справочники.Цеха.ОсновнойЦех Тогда
					RequestItemJobs.WorkType = "2";          	
				Иначе
					RequestItemJobs.WorkType = "1";    
				КонецЕсли;     			
				RequestItemJobs.ServiceType	= КраткоеОбозначение;
	            RequestItemJobs.TCEmployeeID = "";
				RequestItemJobs.TCEmployeeName = "";
				
				CommentsType = ФабрикаXDTO.Тип("http://wa.dms.webservice/RepairOrderGetRequest", "ArrayOfComment");
				Comments = ФабрикаXDTO.Создать(CommentsType);
				RequestItemJobs.Comments = Comments;    			
				DescriptionsType = ФабрикаXDTO.Тип("http://wa.dms.webservice/RepairOrderGetRequest", "ArrayOfDescription");
				Descriptions = ФабрикаXDTO.Создать(DescriptionsType);
				RequestItemJobs.Descriptions = Descriptions;
				
				OPCodes = ФабрикаXDTO.Создать(OPCodesType);  			
				OPCode = ФабрикаXDTO.Создать(OPCodeType); 
	            OPCode.SequenceNumber = "";
				OPCode.OPCodeType = "2";
				OPCode.Code = "OP_Part";
	 			OPCode.Description = "";
				OPCode.EstimatedHours = "";   
				OPCode.ActualHours = "";
				OPCode.SkillLevel = "";
				OPCode.ServiceType = КраткоеОбозначение;
	            OPCode.Quantity = "";
				
				PriceType = ФабрикаXDTO.Тип("http://wa.dms.webservice/RepairOrderGetRequest", "PriceType");
				Price = ФабрикаXDTO.Создать(PriceType); 
				OPCode.PriceType = Price;       
				DescriptionsType = ФабрикаXDTO.Тип("http://wa.dms.webservice/RepairOrderGetRequest", "ArrayOfDescription");
				Descriptions = ФабрикаXDTO.Создать(DescriptionsType);
				OPCode.Descriptions = Descriptions;  			
				CausesType = ФабрикаXDTO.Тип("http://wa.dms.webservice/RepairOrderGetRequest", "ArrayOfCause");
				Causes = ФабрикаXDTO.Создать(CausesType);
				OPCode.Causes = Causes;                			
				CorrectionsType = ФабрикаXDTO.Тип("http://wa.dms.webservice/RepairOrderGetRequest", "ArrayOfCorrection");
				Corrections = ФабрикаXDTO.Создать(CorrectionsType);
				OPCode.Corrections = Corrections;
				
				PartsType = ФабрикаXDTO.Тип("http://wa.dms.webservice/RepairOrderGetRequest", "ArrayOfPart");
				Parts = ФабрикаXDTO.Создать(PartsType); 			

				ЗапросТовары = Новый Запрос;
				ЗапросТовары.Параметры.Вставить("ДатаЗаказНаряда", Выборка.Дата);
				ЗапросТовары.Параметры.Вставить("ЗаказНарядСсылка", Выборка.Ссылка);
				ЗапросТовары.Параметры.Вставить("Организация", Выборка.Ссылка.Организация);
				ЗапросТовары.Текст = "ВЫБРАТЬ
				                     |	ЗаказНарядТовары.НомерСтроки,
				                     |	ЗаказНарядТовары.Основная,
				                     |	ЗаказНарядТовары.Номенклатура.Наименование КАК Наименование,
				                     |	ЗаказНарядТовары.Номенклатура.Артикул КАК Артикул,
				                     |	ЗаказНарядТовары.ЕдиницаИзмерения.Наименование КАК ЕдиницаИзмерения,
				                     |	ЗаказНарядТовары.Номенклатура.Производитель.Родитель КАК Производитель,
				                     |	ЗаказНарядТовары.Количество,
				                     |	ЗаказНарядТовары.Цена,
				                     |	ЗаказНарядТовары.СуммаВсего,
				                     |	ЗаказНарядТовары.ПроцентСкидки,
				                     |	ЗаказНарядТовары.СуммаСкидки,
				                     |	ЗаказНарядТовары.ПроцентСкидкиСтроки,
				                     |	ЗаказНарядТовары.СуммаСкидкиСтроки,
				                     |	ЕСТЬNULL(ОстаткиТоваровКомпанииОстатки.КоличествоОстаток, 0) - ЕСТЬNULL(ОстаткиТоваровКомпанииОстатки.РезервОстаток, 0) КАК СвободныйОстаток,
				                     |	ЕСТЬNULL(Продажи.Партия.ВхДокНомер, """") КАК ВхДокументНомер
				                     |ИЗ
				                     |	Документ.ЗаказНаряд.Товары КАК ЗаказНарядТовары
				                     |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ОстаткиТоваровКомпании.Остатки(&ДатаЗаказНаряда, СкладКомпании.Организация = &Организация) КАК ОстаткиТоваровКомпанииОстатки
				                     |		ПО ЗаказНарядТовары.Номенклатура = ОстаткиТоваровКомпанииОстатки.Номенклатура
				                     |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.Продажи КАК Продажи
				                     |		ПО (Продажи.Регистратор = ЗаказНарядТовары.Ссылка
				                     |				И Продажи.Номенклатура = ЗаказНарядТовары.Номенклатура
				                     |				И Продажи.Партия ССЫЛКА Документ.ПоступлениеТоваров)
				                     |ГДЕ
				                     |	ЗаказНарядТовары.Ссылка = &ЗаказНарядСсылка";
							   
				РезультатТовары = ЗапросТовары.Выполнить().Выгрузить();
				PartType = ФабрикаXDTO.Тип("http://wa.dms.webservice/RepairOrderGetRequest", "Part");
				Для Каждого СтрокаТовар Из РезультатТовары Цикл
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
					Part.DocumentNo = СтрокаТовар.ВхДокументНомер;
					Если ЗначениеЗаполнено(Part.DocumentNo) Тогда
						Part.DocumentType = "2";
					Иначе
						Part.DocumentType = "3";
					КонецЕсли;
					Part.UnitOfMeasure = СтрокаТовар.ЕдиницаИзмерения; 				
			        Part.Quantity = Формат(СтрокаТовар.Количество, "ЧЦ=15; ЧДЦ=2; ЧРД=.; ЧГ=0");
					Part.ServiceType = КраткоеОбозначение;
					
	                PriceType = ФабрикаXDTO.Тип("http://wa.dms.webservice/RepairOrderGetRequest", "PriceType");
					Price = ФабрикаXDTO.Создать(PriceType); 
					Price.UnitPrice = Формат(СтрокаТовар.Цена,"ЧЦ=15; ЧДЦ=2; ЧРД=.; ЧГ=0");
					Price.TotalPrice = Формат(СтрокаТовар.СуммаВсего,"ЧЦ=15; ЧДЦ=2; ЧРД=.; ЧГ=0");
					Price.TotalPriceIncludeTax = Формат(СтрокаТовар.СуммаВсего,"ЧЦ=15; ЧДЦ=2; ЧРД=.; ЧГ=0");
					Price.DiscountRate = Формат(?(обЗначениеНеЗаполнено(СтрокаТовар.ПроцентСкидки), СтрокаТовар.ПроцентСкидкиСтроки, СтрокаТовар.ПроцентСкидки),"ЧЦ=15; ЧДЦ=2; ЧРД=.; ЧГ=0");
					Price.DiscountPrice = Формат(СтрокаТовар.СуммаСкидки + СтрокаТовар.СуммаСкидкиСтроки,"ЧЦ=15; ЧДЦ=2; ЧРД=.; ЧГ=0");
					Part.PriceType = Price;
					
					DescriptionsType = ФабрикаXDTO.Тип("http://wa.dms.webservice/RepairOrderGetRequest", "ArrayOfDescription");
					Descriptions = ФабрикаXDTO.Создать(DescriptionsType);
					Part.Descriptions = Descriptions;  
					Parts.Part.Добавить(Part);
					
					Если НЕ СтрокаТовар.Основная Тогда
						СуммаДоп = СуммаДоп + СтрокаТовар.СуммаВсего;	
					КонецЕсли;
				КонецЦикла;	
				
				AdditionalField = ФабрикаXDTO.Создать(AdditionalFieldType); 
				AdditionalField.AdditionalFieldName = "AdditionalRepairOrderSummary";
                AdditionalField.AdditionalFieldValue = Формат(СуммаДоп, "ЧЦ=15; ЧДЦ=2; ЧРД=.; ЧГ=0");
                AdditionalFields.AdditionalField.Добавить(AdditionalField);
				
				AdditionalField = ФабрикаXDTO.Создать(AdditionalFieldType); 
				AdditionalField.AdditionalFieldName = "SAComment";
                AdditionalField.AdditionalFieldValue = СокрЛП(Выборка.Ссылка.Рекомендации);
                AdditionalFields.AdditionalField.Добавить(AdditionalField);
				RepairOrder.AdditionalFields = AdditionalFields;
				
				OPCode.Parts = Parts; 
				SubletsType = ФабрикаXDTO.Тип("http://wa.dms.webservice/RepairOrderGetRequest", "ArrayOfSublet");
				Sublets = ФабрикаXDTO.Создать(SubletsType);
				OPCode.Sublets = Sublets; 
				MISCsType = ФабрикаXDTO.Тип("http://wa.dms.webservice/RepairOrderGetRequest", "ArrayOfMISC");
				MISCs = ФабрикаXDTO.Создать(MISCsType);
				OPCode.MISCs = MISCs; 
				
				OPCodes.OPCode.Добавить(OPCode);
				RequestItemJobs.OPCodes = OPCodes; 
	            RequestItems.RequestItem.Добавить(RequestItemJobs);
	            RepairOrder.RequestItems = RequestItems;   	
							
				RepairOrders.RepairOrder.Добавить(RepairOrder);
			КонецЦикла;
			RepairOrderDocument.RepairOrders = RepairOrders;
			RepairOrderDocuments.RepairOrderDocument.Добавить(RepairOrderDocument);
		КонецЦикла;
	КонецЕсли;

    RepairOrderGet.RepairOrderDocuments = RepairOrderDocuments;
	RepairOrderGet = обПолучитьВозвратWAError("http://wa.dms.webservice/RepairOrderGetRequest",RepairOrderGetRequest,RepairOrderGet,"1",ТаблицаОщибок);
	Возврат RepairOrderGet;  	   
КонецФункции

Функция RepairOrderChange(RepairOrderChangeRequest)
	// Вставить содержимое обработчика.
	глПрава = обПолучитьПраваИНастройкиПользователя(ПараметрыСеанса.Пользователь);

	RepairOrderChangeType = ФабрикаXDTO.Тип("http://wa.dms.webservice/RepairOrderGetRequest", "RepairOrderChangeResponse");
	RepairOrderChange = ФабрикаXDTO.Создать(RepairOrderChangeType);  
	
	ТаблицаОщибок = Новый ТаблицаЗначений;
	ТаблицаОщибок.Колонки.Добавить("Код",	 Новый ОписаниеТипов("Строка"));
	ТаблицаОщибок.Колонки.Добавить("ТекстОшибки",		 Новый ОписаниеТипов("Строка"));   
		
	Попытка
		НомерЗаказНаряда = RepairOrderChangeRequest.RepairOrderChange.DMSRONo;
	Исключение
		НомерЗаказНаряда = Неопределено;
	КонецПопытки;  
	Попытка
		IDЗаказНаряда = RepairOrderChangeRequest.RepairOrderChange.DMSROID;
	Исключение
		IDЗаказНаряда = Неопределено;
	КонецПопытки;  
	Попытка
		ПланируемаяДатаВыдачи = RepairOrderChangeRequest.RepairOrderChange.DeliveryDateTimeLocal;
	Исключение
		ПланируемаяДатаВыдачи = Дата('00010101');
	КонецПопытки;  
	Попытка
		ДатаНачала = RepairOrderChangeRequest.RepairOrderChange.OpenDateTimeLocal;
	Исключение
		ДатаНачала = Дата('00010101');
	КонецПопытки;  
	Попытка
		ДатаЗакрытия = RepairOrderChangeRequest.RepairOrderChange.CloseDateTimeLocal;
	Исключение
		ДатаЗакрытия = Дата('00010101');
	КонецПопытки;  
    Попытка
		СостояниеЗаказНаряда = RepairOrderChangeRequest.RepairOrderChange.DMSROStatus;
	Исключение
		СостояниеЗаказНаряда = "";
	КонецПопытки;  
    Попытка
		ВидРемонта = RepairOrderChangeRequest.RepairOrderChange.ServiceType;
	Исключение
		ВидРемонта = "";
	КонецПопытки;  
    Попытка
		ТипОплаты = RepairOrderChangeRequest.RepairOrderChange.PaymentMethod;
	Исключение
		ТипОплаты = "";
	КонецПопытки;   
    Попытка
		ПробегНаНачало = RepairOrderChangeRequest.RepairOrderChange.InMileage;
	Исключение
		ПробегНаНачало = "";
	КонецПопытки; 
    Попытка
		ПробегНаКонец = RepairOrderChangeRequest.RepairOrderChange.OutMileage;
	Исключение
		ПробегНаКонец = "";
	КонецПопытки; 
    Попытка
		КодМастера = RepairOrderChangeRequest.RepairOrderChange.SAEmployeeID;
	Исключение
		КодМастера = "";
	КонецПопытки;     
	Попытка
		НаименованиеМастера = RepairOrderChangeRequest.RepairOrderChange.SAEmployeeName;
	Исключение
		НаименованиеМастера = "";
	КонецПопытки;
	
	// ОПЦИИ
	Согласие = "";
	Ожидание = "";
	СогласовыватьПоТел = "";
	ХранитьДемонтЗч = "";
	Попытка
		МассивОпций = RepairOrderChangeRequest.RepairOrderChange.Options;  
		Для Каждого Опция Из МассивОпций.Option Цикл
			// Согласие на обработку ПД
			//Если Опция.OptionName = "PersonalInfoAgreeYN" Тогда
			//	Согласие = Опция.OptionValue;
			//КонецЕсли;
			 // Ожидание в дилерском центре
			Если Опция.OptionName = "WaitYN" Тогда
				Ожидание = Опция.OptionValue;
			КонецЕсли;
			 // Согласование по телефону
			Если Опция.OptionName = "AgreeToCallYN" Тогда
				СогласовыватьПоТел = Опция.OptionValue;
			КонецЕсли;
			 // Хранить демонтированные ЗЧ
			Если Опция.OptionName = "SaveReplacePartYN" Тогда
				ХранитьДемонтЗч = Опция.OptionValue;
			КонецЕсли;
		КонецЦикла; 
	Исключение
	КонецПопытки;

    Попытка
		ПричинаОбращения = RepairOrderChangeRequest.RepairOrderChange.Description;
	Исключение
		ПричинаОбращения = "";
	КонецПопытки;
	Если НомерЗаказНаряда <> Неопределено Тогда
		Если ЗначениеЗаполнено(НомерЗаказНаряда) Тогда 
			ЗаказНарядСсылка = Документы.ЗаказНаряд.НайтиПоНомеру(НомерЗаказНаряда, ТекущаяДата());
			Если ЗаказНарядСсылка.Пустая() Тогда
                НоваяСтрока = ТаблицаОщибок.Добавить();
				НоваяСтрока.Код = "ROC29";
				НоваяСтрока.ТекстОшибки = "Заказ-наряд с указанным номером не найден";
				RepairOrderChange = обПолучитьВозвратWAError("http://wa.dms.webservice/RepairOrderGetRequest",RepairOrderChangeRequest,RepairOrderChange,"-1",ТаблицаОщибок);
				Возврат RepairOrderChange;
			Иначе
				ЗаказНарядОбъект = ЗаказНарядСсылка.ПолучитьОбъект();	
			КонецЕсли;
		Иначе
			НоваяСтрока = ТаблицаОщибок.Добавить();
			НоваяСтрока.Код = "ROC29";
			НоваяСтрока.ТекстОшибки = "Некорректный номер заказ-наряда";
			RepairOrderChange = обПолучитьВозвратWAError("http://wa.dms.webservice/RepairOrderGetRequest",RepairOrderChangeRequest,RepairOrderChange,"-1",ТаблицаОщибок);
			Возврат RepairOrderChange;   	
		КонецЕсли;
	Иначе
		Если IDЗаказНаряда <> Неопределено Тогда
			Если ЗначениеЗаполнено(IDЗаказНаряда) Тогда
				ЗаказНарядСсылка = Документы.ЗаказНаряд.ПолучитьСсылку(IDЗаказНаряда);
				ЗаказНарядОбъект = ЗаказНарядСсылка.ПолучитьОбъект();
				Если ЗаказНарядОбъект = Неопределено Тогда
					НоваяСтрока = ТаблицаОщибок.Добавить();
					НоваяСтрока.Код = "WA03";
					НоваяСтрока.ТекстОшибки = "Заказ-наряд с указанным идентификатором не найден";
					RepairOrderChange = обПолучитьВозвратWAError("http://wa.dms.webservice/RepairOrderGetRequest",RepairOrderChangeRequest,RepairOrderChange,"-1",ТаблицаОщибок);
					Возврат RepairOrderChange;   	   			
				КонецЕсли;
			Иначе
				НоваяСтрока = ТаблицаОщибок.Добавить();
				НоваяСтрока.Код = "WA03";
				НоваяСтрока.ТекстОшибки = "Некорректный ID заказ-наряда";
				RepairOrderChange = обПолучитьВозвратWAError("http://wa.dms.webservice/RepairOrderGetRequest",RepairOrderChangeRequest,RepairOrderChange,"-1",ТаблицаОщибок);
				Возврат RepairOrderChange;   	   			
			КонецЕсли;
		Иначе
			НоваяСтрока = ТаблицаОщибок.Добавить();
			НоваяСтрока.Код = "WA03";
			НоваяСтрока.ТекстОшибки = "Некорректный ID заказ-наряда";
			RepairOrderChange = обПолучитьВозвратWAError("http://wa.dms.webservice/RepairOrderGetRequest",RepairOrderChangeRequest,RepairOrderChange,"-1",ТаблицаОщибок);
			Возврат RepairOrderChange;   
		КонецЕсли;
	КонецЕсли;  
	
	Если ЗаказНарядСсылка.Состояние = Справочники.ВидыСостоянийЗаказНарядов.Закрыт  ИЛИ ЗаказНарядСсылка.Состояние = Справочники.ВидыСостоянийЗаказНарядов.Отказ Тогда
		НоваяСтрока = ТаблицаОщибок.Добавить();
		НоваяСтрока.Код = "ROC01";
		НоваяСтрока.ТекстОшибки = "Заказ-наряд с статусе '"+Строка(ЗаказНарядСсылка.Состояние)+"' не доступен для редактирования.";
		RepairOrderChange = обПолучитьВозвратWAError("http://wa.dms.webservice/RepairOrderGetRequest",RepairOrderChangeRequest,RepairOrderChange,"-1",ТаблицаОщибок);
		Возврат RepairOrderChange;   
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДатаНачала) Тогда
		ЗаказНарядОбъект.ДатаНачала = ДатаНачала;  				
	КонецЕсли;  	

	Если ЗначениеЗаполнено(ПланируемаяДатаВыдачи) Тогда   		
		ЗаказНарядОбъект.ПлановаяДатаВыдачи = ПланируемаяДатаВыдачи;   
	КонецЕсли;   	                                      

	Если ЗначениеЗаполнено(ДатаЗакрытия) Тогда
		ЗаказНарядОбъект.ДатаОкончания = ДатаЗакрытия;  				
	КонецЕсли;   	
	
	ЗаказчикФизЛицо = ЗаказНарядОбъект.Заказчик.ФормаСобственности = Перечисления.ФормыСобственности.ЧастноеЛицо;
	Если ЗначениеЗаполнено(СостояниеЗаказНаряда) Тогда
		Если СостояниеЗаказНаряда = "1" Тогда
			Состояние = Справочники.ВидыСостоянийЗаказНарядов.Заявка;	
		ИначеЕсли СостояниеЗаказНаряда = "2" Тогда
			Состояние = Справочники.ВидыСостоянийЗаказНарядов.ВРаботе;
		ИначеЕсли СостояниеЗаказНаряда = "3" Тогда
			Состояние = Справочники.ВидыСостоянийЗаказНарядов.Согласование;
		ИначеЕсли СостояниеЗаказНаряда = "4" Тогда
			Состояние = Справочники.ВидыСостоянийЗаказНарядов.Ожидание;
		ИначеЕсли СостояниеЗаказНаряда = "5" Тогда
			Состояние = Справочники.ВидыСостоянийЗаказНарядов.Стоянка;
		ИначеЕсли СостояниеЗаказНаряда = "6" Тогда
			Состояние = Справочники.ВидыСостоянийЗаказНарядов.Выполнен;
		ИначеЕсли СостояниеЗаказНаряда = "7" Тогда
			Состояние = Справочники.ВидыСостоянийЗаказНарядов.Закрыт;
		ИначеЕсли СостояниеЗаказНаряда = "8" Тогда
			Состояние = Справочники.ВидыСостоянийЗаказНарядов.ВРезерве;
		ИначеЕсли СостояниеЗаказНаряда = "9" Тогда
			Состояние = Справочники.ВидыСостоянийЗаказНарядов.Отказ;
		Иначе
			НоваяСтрока = ТаблицаОщибок.Добавить();
			НоваяСтрока.Код = "WA03";
			НоваяСтрока.ТекстОшибки = "Некорректный статус заказ-наряда";
			RepairOrderChange = обПолучитьВозвратWAError("http://wa.dms.webservice/RepairOrderGetRequest",RepairOrderChangeRequest,RepairOrderChange,"-1",ТаблицаОщибок);
			Возврат RepairOrderChange;   
		КонецЕсли;    
		ЗаказНарядОбъект.Состояние = Состояние; 	
		
		Если Состояние = Справочники.ВидыСостоянийЗаказНарядов.Выполнен Тогда 
			АктуальныеОтзывныеКампании = орПроверитьСервиснуюКампанию(ЗаказНарядСсылка.Автомобиль,ЗаказНарядСсылка.ДатаОкончания,Истина,ЗаказНарядСсылка);
			Если АктуальныеОтзывныеКампании.Количество()>0 Тогда
				ОтказПоОтзывным = Истина;
				Для Каждого Строка Из АктуальныеОтзывныеКампании Цикл
					Если Строка.СервиснаяКампания = ЗаказНарядСсылка.СервиснаяКампания Тогда
						Если ЗаказНарядСсылка.ВидРемонта.Гарантия.Количество()>0 Тогда
							ОтказПоОтзывным = Ложь;
						КонецЕсли;
					КонецЕсли;
				КонецЦикла;		
				Если ОтказПоОтзывным Тогда
					НоваяСтрока = ТаблицаОщибок.Добавить();
					НоваяСтрока.Код = "ROC30";
					НоваяСтрока.ТекстОшибки = "Существуют актуальные отзывные кампании. Перевод в статус <Выполнен> невозможен. Обратитесь к инженеру по гарантии или сервис-менеджеру.";
					RepairOrderChange = обПолучитьВозвратWAError("http://wa.dms.webservice/RepairOrderGetRequest",RepairOrderChangeRequest,RepairOrderChange,"-1",ТаблицаОщибок);
					Возврат RepairOrderChange;     
				КонецЕсли;
			КонецЕсли;
			
			Если ЗаказчикФизЛицо Тогда
				СогласиеНаОПД = ЗаказНарядОбъект.Заказчик.СогласиеНаОбработкуПерсональныхДанных;
				Если ЗаказНарядОбъект.ВидРемонта.ГарантияЗавода Тогда  			
					Если СогласиеНаОПД = Перечисления.ВариантыОтветов.Да Тогда
						Если ЗначениеЗаполнено(ЗаказНарядОбъект.Заказчик._г_ДатаОкончанияСогласия) Тогда 
							Если ЗаказНарядОбъект.Заказчик._г_ДатаОкончанияСогласия < ТекущаяДата() Тогда 
								НоваяСтрока = ТаблицаОщибок.Добавить();
								НоваяСтрока.Код = "ROC31";
								НоваяСтрока.ТекстОшибки = "Внимание! У клиента просрочена дата окончания согласия на обработку персональных данных!";
								RepairOrderChange = обПолучитьВозвратWAError("http://wa.dms.webservice/RepairOrderGetRequest",RepairOrderChangeRequest,RepairOrderChange,"-1",ТаблицаОщибок);
								Возврат RepairOrderChange;       
							КонецЕсли;					
						КонецЕсли; 					

					ИначеЕсли СогласиеНаОПД = Перечисления.ВариантыОтветов.Спрашивать Тогда
						НоваяСтрока = ТаблицаОщибок.Добавить();
						НоваяСтрока.Код = "ROC31";
						НоваяСтрока.ТекстОшибки = "Внимание! У клиента не заполнено согласие на обработку персональных данных!";
						RepairOrderChange = обПолучитьВозвратWAError("http://wa.dms.webservice/RepairOrderGetRequest",RepairOrderChangeRequest,RepairOrderChange,"-1",ТаблицаОщибок);
						Возврат RepairOrderChange;       
					КонецЕсли;       			

				ИначеЕсли СогласиеНаОПД = Перечисления.ВариантыОтветов.Спрашивать Тогда    
					НоваяСтрока = ТаблицаОщибок.Добавить();
					НоваяСтрока.Код = "ROC31";
					НоваяСтрока.ТекстОшибки = "Внимание! У клиента не заполнено согласие на обработку персональных данных!";
					RepairOrderChange = обПолучитьВозвратWAError("http://wa.dms.webservice/RepairOrderGetRequest",RepairOrderChangeRequest,RepairOrderChange,"-1",ТаблицаОщибок);
					Возврат RepairOrderChange;       
				КонецЕсли;    				
			КонецЕсли;		
        КонецЕсли;  		
	КонецЕсли;  	
	
	Если ЗначениеЗаполнено(ВидРемонта) Тогда
		ВидРемонтаСсылка = Справочники.ВидыРемонта.НайтиПоРеквизиту("КраткоеОбозначение",ВидРемонта);
		Если ВидРемонтаСсылка = Справочники.ВидыРемонта.ПустаяСсылка() Тогда
			НоваяСтрока = ТаблицаОщибок.Добавить();
			НоваяСтрока.Код = "ROC03";
			НоваяСтрока.ТекстОшибки = "Некорректный вид ремонта для заказ-наряда";
			RepairOrderChange = обПолучитьВозвратWAError("http://wa.dms.webservice/RepairOrderGetRequest",RepairOrderChangeRequest,RepairOrderChange,"-1",ТаблицаОщибок);
			Возврат RepairOrderChange;  
		Иначе
			ЗаказНарядОбъект.ВидРемонта = ВидРемонтаСсылка;
		КонецЕсли;
	КонецЕсли;  	
	
	Если ЗначениеЗаполнено(КодМастера) Тогда
		МастерСсылка = Справочники.Сотрудники.НайтиПоКоду(КодМастера);
		Если МастерСсылка.Пустая() Тогда
			НоваяСтрока = ТаблицаОщибок.Добавить();
			НоваяСтрока.Код = "WA03";
			НоваяСтрока.ТекстОшибки = "Сотрудник с заданным кодом не найден";
			RepairOrderChange = обПолучитьВозвратWAError("http://wa.dms.webservice/RepairOrderGetRequest",RepairOrderChangeRequest,RepairOrderChange,"-1",ТаблицаОщибок);
			Возврат RepairOrderChange;  	
		Иначе
			ЗаказНарядОбъект.Диспетчер = МастерСсылка;
		КонецЕсли;
	КонецЕсли;  	
	
	Если ЗначениеЗаполнено(ТипОплаты) Тогда
		Если ТипОплаты = "1" Тогда
			ЗаказНарядОбъект.ВидОплаты = Перечисления.ВидыОплаты.НаличныйРасчет;
		ИначеЕсли ТипОплаты = "3" Тогда 
			ЗаказНарядОбъект.ВидОплаты = Перечисления.ВидыОплаты.БанковскаяКарта;
		ИначеЕсли ТипОплаты = "2" Тогда 
			ЗаказНарядОбъект.ВидОплаты = Перечисления.ВидыОплаты.БезналичныйРасчет;
		КонецЕсли;   
	КонецЕсли;  	
	
	Если ЗначениеЗаполнено(ПричинаОбращения) Тогда         
		ЗаказНарядОбъект.ПричинаОбращения = ПричинаОбращения;
	КонецЕсли;    
						
	Если ЗначениеЗаполнено(ПробегНаНачало) Тогда
		Пробег = Число(ПробегНаНачало);
		Отказ = Справочники.Автомобили.ЗаписьЗначенияРегистраСведения(ЗаказНарядОбъект.Автомобиль, Пробег, 
							Перечисления.ДополнительнаяИнформацияАвтомобилей.Пробег, ЗаказНарядОбъект.ДатаСоздания);
		Если Отказ Тогда
			НоваяСтрока = ТаблицаОщибок.Добавить();
			НоваяСтрока.Код = "ROC05";
			НоваяСтрока.ТекстОшибки = "Пробег автомобиля не может быть меньше установленного ранее значения!";
			RepairOrderChange = обПолучитьВозвратWAError("http://wa.dms.webservice/RepairOrderGetRequest",RepairOrderChangeRequest,RepairOrderChange,"-1",ТаблицаОщибок);
			Возврат RepairOrderChange;
		Иначе
			ЗаказНарядОбъект.Пробег = Пробег; 
		КонецЕсли;     
	КонецЕсли;  
	
	Если ЗначениеЗаполнено(Ожидание) Тогда
		ЗаказНарядОбъект.Ожидает = ?(Ожидание = "Y", Перечисления.Ожидание.ВСалоне, Перечисления.Ожидание.ВнеСалона);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СогласовыватьПоТел) Тогда
		ЗаказНарядОбъект.Согласование = ?(СогласовыватьПоТел = "Y", Перечисления.Согласование.ПоТелефону, Перечисления.Согласование.Лично);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ХранитьДемонтЗч) Тогда
		ЗаказНарядОбъект.ДемонтированныеЗапчасти = ?(ХранитьДемонтЗч = "Y", Перечисления.ДемонтированныеЗапчасти.Сохранить, Перечисления.ДемонтированныеЗапчасти.Утилизировать);  
	КонецЕсли;

    // КОНТРАГЕНТЫ
	ТаблицаКонтрагентов = Новый ТаблицаЗначений;
	ТаблицаКонтрагентов.Колонки.Добавить("CustomerInfoType",	 Новый ОписаниеТипов("Строка"));
	ТаблицаКонтрагентов.Колонки.Добавить("DMSCustomerNo",		 Новый ОписаниеТипов("Строка"));
	ТаблицаКонтрагентов.Колонки.Добавить("FullName",			 Новый ОписаниеТипов("Строка"));
	ТаблицаКонтрагентов.Колонки.Добавить("Gender",				 Новый ОписаниеТипов("Строка"));
    ТаблицаКонтрагентов.Колонки.Добавить("Email",		 		 Новый ОписаниеТипов("Строка"));
	ТаблицаКонтрагентов.Колонки.Добавить("Message",				 Новый ОписаниеТипов("Строка"));
	ТаблицаКонтрагентов.Колонки.Добавить("ContactPersonID",		 Новый ОписаниеТипов("Строка"));
	ТаблицаКонтрагентов.Колонки.Добавить("ContactPersonName",	 Новый ОписаниеТипов("Строка"));
	ТаблицаКонтрагентов.Колонки.Добавить("ContactPhone",		 Новый ОписаниеТипов("Строка"));
	
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
		МассивКонтрагентов = RepairOrderChangeRequest.RepairOrderChange.Customers;  
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
				НоваяСтрока.ТекстОшибки = "Некорректный тип контрагента.";
				RepairOrderChange = обПолучитьВозвратWAError("http://wa.dms.webservice/RepairOrderGetRequest",RepairOrderChangeRequest,RepairOrderChange,"-1",ТаблицаОщибок);
				Возврат RepairOrderChange;     
			КонецПопытки;   			
			Попытка
				НоваяСтрока.DMSCustomerNo = Контрагент.DMSCustomerNo;
			Исключение    
				НоваяСтрока = ТаблицаОщибок.Добавить();
				НоваяСтрока.Код = "ROC06";
				НоваяСтрока.ТекстОшибки = "Не задан код контрагента.";
				RepairOrderChange = обПолучитьВозвратWAError("http://wa.dms.webservice/RepairOrderGetRequest",RepairOrderChangeRequest,RepairOrderChange,"-1",ТаблицаОщибок);
				Возврат RepairOrderChange;   
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
						НоваяСтрока.ТекстОшибки = "Некорректный тип адреса.";
						RepairOrderChange = обПолучитьВозвратWAError("http://wa.dms.webservice/RepairOrderGetRequest",RepairOrderChangeRequest,RepairOrderChange,"-1",ТаблицаОщибок);
						Возврат RepairOrderChange;        
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
						НоваяСтрока.ТекстОшибки = "Некорректный тип телефона.";
						RepairOrderChange = обПолучитьВозвратWAError("http://wa.dms.webservice/RepairOrderGetRequest",RepairOrderChangeRequest,RepairOrderChange,"-1",ТаблицаОщибок);
						Возврат RepairOrderChange;      
					КонецПопытки;
					Попытка					
						НоваяСтрокаТел.ContactValue = Телефон.ContactValue;
					Исключение
						НоваяСтрока = ТаблицаОщибок.Добавить();
						НоваяСтрока.Код = "ROC08";
						НоваяСтрока.ТекстОшибки = "Некорректный телефон.";
						RepairOrderChange = обПолучитьВозвратWAError("http://wa.dms.webservice/RepairOrderGetRequest",RepairOrderChangeRequest,RepairOrderChange,"-1",ТаблицаОщибок);
						Возврат RepairOrderChange;  
					КонецПопытки;
					Попытка
						НоваяСтрокаТел.ContactMethodYN = Телефон.ContactMethodYN;
					Исключение
					КонецПопытки;
				КонецЦикла; 
			КонецЕсли; 
			
			Попытка
            	МассивКонтактныхЛицКонтрагента = Контрагент.CorporateInfos;
			Исключение
				МассивКонтактныхЛицКонтрагента = Неопределено;
			КонецПопытки;
			
			Если НЕ МассивКонтактныхЛицКонтрагента = Неопределено Тогда
				Для Каждого ЭлКонтЛицо Из МассивКонтактныхЛицКонтрагента.CorporateInfo Цикл
					Если ЭлКонтЛицо.CorporateInfoName = "ContactPerson" Тогда
						НоваяСтрока.ContactPersonName = ЭлКонтЛицо.CorporateInfoValue;	
					КонецЕсли;
					Если ЭлКонтЛицо.CorporateInfoName = "ContactNumber" Тогда
						НоваяСтрока.ContactPhone = ЭлКонтЛицо.CorporateInfoValue; 
					КонецЕсли;
					Если ЭлКонтЛицо.CorporateInfoName = "ContactPersonID" Тогда
						НоваяСтрока.ContactPersonID = ЭлКонтЛицо.CorporateInfoValue;	
					КонецЕсли;    
				КонецЦикла;
			КонецЕсли;

		КонецЦикла; 
	КонецЕсли;
	
	Для Каждого КонтрСтрока Из ТаблицаКонтрагентов Цикл
		Если обЗначениеНеЗаполнено(КонтрСтрока.DMSCustomerNo)  Тогда 
			НоваяСтрока = ТаблицаОщибок.Добавить();
			НоваяСтрока.Код = "ROC06";
			НоваяСтрока.ТекстОшибки = "Не указан код контрагента.";
			RepairOrderChange = обПолучитьВозвратWAError("http://wa.dms.webservice/RepairOrderGetRequest",RepairOrderChangeRequest,RepairOrderChange,"-1",ТаблицаОщибок);
			Возврат RepairOrderChange;  
		КонецЕсли; 					
		КонтрСсылка = Справочники.Контрагенты.НайтиПоКоду(КонтрСтрока.DMSCustomerNo);
	    Если КонтрСсылка = Справочники.Контрагенты.ПустаяСсылка() Тогда                     		
			НоваяСтрока = ТаблицаОщибок.Добавить();
			НоваяСтрока.Код = "ROC06";
			НоваяСтрока.ТекстОшибки = "Контрагент с указанным кодом не найден";
			RepairOrderChange = обПолучитьВозвратWAError("http://wa.dms.webservice/RepairOrderGetRequest",RepairOrderChangeRequest,RepairOrderChange,"-1",ТаблицаОщибок);
			Возврат RepairOrderChange;   
		Иначе
			КонтрОбъект = КонтрСсылка.ПолучитьОбъект(); 
			Если КонтрСтрока.CustomerInfoType = "2" Тогда // Customer    
				ЗаказНарядОбъект.Контрагент = КонтрСсылка;
				Если ЗначениеЗаполнено(Согласие) Тогда
					НовыйВариант = ?(Согласие = "Y", Перечисления.ВариантыОтветов.Да, Перечисления.ВариантыОтветов.Нет);
					Если КонтрОбъект.СогласиеНаОбработкуПерсональныхДанных <> НовыйВариант Тогда
						НоваяСтрока = ТаблицаОщибок.Добавить();
						НоваяСтрока.Код = "WA03";
						НоваяСтрока.ТекстОшибки = "Изменение реквизита ""Согласие на обработку на персональных данных"" запрещено!";
						RepairOrderChange = обПолучитьВозвратWAError("http://wa.dms.webservice/RepairOrderGetRequest",RepairOrderChangeRequest,RepairOrderChange,"-1",ТаблицаОщибок);
						Возврат RepairOrderChange;
					КонецЕсли;
				КонецЕсли;			
			ИначеЕсли КонтрСтрока.CustomerInfoType = "1" Тогда
				//ЗаказНарядОбъект.Заказчик = КонтрСсылка; 
			КонецЕсли;
			 			
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
			
			КонтрОбъект.ОбменДанными.Загрузка = Истина;
			Попытка
				КонтрОбъект.Записать();
			Исключение
				НоваяСтрока = ТаблицаОщибок.Добавить();
				НоваяСтрока.Код = "WA03";
				НоваяСтрока.ТекстОшибки = ОписаниеОшибки();
				RepairOrderChange = обПолучитьВозвратWAError("http://wa.dms.webservice/RepairOrderGetRequest",RepairOrderChangeRequest,RepairOrderChange,"-1",ТаблицаОщибок);
				Возврат RepairOrderChange;
			КонецПопытки; 					
			
			Если ЗначениеЗаполнено(КонтрСтрока.Email) Тогда
				Запись = РегистрыСведений.КонтактнаяИнформация.СоздатьМенеджерЗаписи();
				Запись.Объект = КонтрСсылка;
		   		Запись.Тип = Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты;
				Если КонтрСсылка.ФормаСобственности = Перечисления.ФормыСобственности.ЧастноеЛицо Тогда
					Запись.Вид = Справочники.ВидыКонтактнойИнформации.АдресЭлектроннойПочтыДомашний;
				Иначе
					Запись.Вид = Справочники.ВидыКонтактнойИнформации.АдресЭлектроннойПочтыРабочий;
				КонецЕсли;    
				Запись.Представление = СокрЛП(КонтрСтрока.Email);
				Попытка
					Запись.Записать(Истина);
				Исключение
					НоваяСтрока = ТаблицаОщибок.Добавить();
					НоваяСтрока.Код = "WA03";
					НоваяСтрока.ТекстОшибки = ОписаниеОшибки();
					RepairOrderChange = обПолучитьВозвратWAError("http://wa.dms.webservice/RepairOrderGetRequest",RepairOrderChangeRequest,RepairOrderChange,"-1",ТаблицаОщибок);
					Возврат RepairOrderChange;      
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
					продолжить;
				КонецЕсли;
				Попытка
					Запись.Записать(Истина);
				Исключение
					НоваяСтрока = ТаблицаОщибок.Добавить();
					НоваяСтрока.Код = "WA03";
					НоваяСтрока.ТекстОшибки = ОписаниеОшибки();
					RepairOrderChange = обПолучитьВозвратWAError("http://wa.dms.webservice/RepairOrderGetRequest",RepairOrderChangeRequest,RepairOrderChange,"-1",ТаблицаОщибок);
					Возврат RepairOrderChange;          
				КонецПопытки;     			
			КонецЦикла; 						
			
			Для Каждого ТелефонСтрока Из ТаблицаТелефонов Цикл 
				Если ТелефонСтрока.DMSCustomerNo <> КонтрСтрока.DMSCustomerNo Тогда
					Продолжить;
				КонецЕсли;
				глПрава = обПолучитьПраваИНастройкиПользователя(ПараметрыСеанса.Пользователь); 	
				ЧислоХранимыхЦифрНомера = обПраво("ПоследниеЦифрыТелефонногоНомера",глПрава);   		
				Запись = РегистрыСведений.КонтактнаяИнформация.СоздатьМенеджерЗаписи();
				Запись.Объект = КонтрСсылка;
		   		Запись.Тип = Перечисления.ТипыКонтактнойИнформации.Телефон;  			
				Если ТелефонСтрока.ContactType =  "1" Тогда // “1” – домашний телефон, “2” – мобильный телефон, “3” – рабочий телефон
					Запись.Вид = Справочники.ВидыКонтактнойИнформации.ТелефонДомашний;
				ИначеЕсли ТелефонСтрока.ContactType = "2" Тогда
					Запись.Вид = Справочники.ВидыКонтактнойИнформации.ТелефонСотовый;
				Иначе
					Запись.Вид = Справочники.ВидыКонтактнойИнформации.ТелефонРабочий;
				КонецЕсли;
				
				Если ЗначениеЗаполнено(ТелефонСтрока.ContactValue) Тогда
					НомерТелефона = СокрЛП(ТелефонСтрока.ContactValue);
					Запись.Поле1 = Лев(НомерТелефона, 2);
					НомерТелефона = кмсфпУбратьИзНомераТелефонаВсеБуквы(НомерТелефона);
					Если СтрДлина(НомерТелефона) < 11 Тогда
						НоваяСтрока = ТаблицаОщибок.Добавить();
						НоваяСтрока.Код = "CVC05";
						НоваяСтрока.ТекстОшибки = "Номер телефона должен содержать не менее 11 цифр";
						RepairOrderChange = обПолучитьВозвратWAError("http://wa.dms.webservice/RepairOrderGetRequest",RepairOrderChangeRequest,RepairOrderChange,"-1",ТаблицаОщибок);
						Возврат RepairOrderChange;            
					КонецЕсли;
					НомерТелефона = Сред(НомерТелефона, 2, 10);
					Запись.Поле2 = Лев(НомерТелефона, 3);
					Запись.Поле3 = Сред(НомерТелефона, 4);
					Запись.Представление = Запись.Поле1 + ", " + Запись.Поле2 + Запись.Поле3;
				Иначе
					Продолжить;
				КонецЕсли;
				Запись.CRM_ПолеХраненияНомера = кмсфпПреобразоватьНомерДляСохранения(ТелефонСтрока.ContactValue, ЧислоХранимыхЦифрНомера);  		
				
				Попытка
					Запись.Записать(Истина);
				Исключение
					НоваяСтрока = ТаблицаОщибок.Добавить();
					НоваяСтрока.Код = "WA03";
					НоваяСтрока.ТекстОшибки = ОписаниеОшибки();
					RepairOrderChange = обПолучитьВозвратWAError("http://wa.dms.webservice/RepairOrderGetRequest",RepairOrderChangeRequest,RepairOrderChange,"-1",ТаблицаОщибок);
					Возврат RepairOrderChange;            
				КонецПопытки; 		
			КонецЦикла; 
			
			// Контактное лицо
			Если ЗначениеЗаполнено(КонтрСтрока.ContactPersonName) Тогда
				Если ЗначениеЗаполнено(КонтрСтрока.ContactPersonID) Тогда // контактное лицо существует
					КонтЛицо = Справочники.Контрагенты.НайтиПоКоду(КонтрСтрока.ContactPersonID);
					Если обЗначениеНеЗаполнено(КонтЛицо) Тогда
						НоваяСтрока = ТаблицаОщибок.Добавить();
						НоваяСтрока.Код = "CVC08";
						НоваяСтрока.ТекстОшибки = "Контактное лицо с указанным кодом не найдено";
						RepairOrderChange = обПолучитьВозвратWAError("http://wa.dms.webservice/RepairOrderGetRequest",RepairOrderChangeRequest,RepairOrderChange,"-1",ТаблицаОщибок);
						Возврат RepairOrderChange;   	
					КонецЕсли;
					КонтЛицоОбъект = КонтЛицо.ПолучитьОбъект(); 
				Иначе
					КонтЛицоОбъект = Справочники.Контрагенты.СоздатьЭлемент();
					КонтЛицоОбъект.УстановитьНовыйКод();
					КонтЛицоОбъект.Родитель = Справочники.Контрагенты.КонтактныеЛица;
					КонтЛицоОбъект.ВидКонтрагента = Перечисления.ВидыКонтрагентов.КонтактноеЛицо;
					КонтЛицоОбъект.ФормаСобственности = Перечисления.ФормыСобственности.ЧастноеЛицо;
					КонтЛицоОбъект.ВедушийКонтрагент = КонтрСсылка;
				КонецЕсли;
				КонтЛицоОбъект.Наименование = КонтрСтрока.ContactPersonName;
				КонтЛицоОбъект.НаименованиеПолное = КонтрСтрока.ContactPersonName;
				КонтЛицоОбъект.ОбменДанными.Загрузка = Истина;
				КонтЛицоОбъект.Записать();
				
				Если ЗначениеЗаполнено(КонтрСтрока.ContactPhone) Тогда
					глПрава = обПолучитьПраваИНастройкиПользователя(ПараметрыСеанса.Пользователь); 	
					ЧислоХранимыхЦифрНомера = обПраво("ПоследниеЦифрыТелефонногоНомера",глПрава);   		
					Запись = РегистрыСведений.КонтактнаяИнформация.СоздатьМенеджерЗаписи();
					Запись.Объект = КонтЛицоОбъект.Ссылка;
			   		Запись.Тип = Перечисления.ТипыКонтактнойИнформации.Телефон;  			
					Запись.Вид = Справочники.ВидыКонтактнойИнформации.ТелефонКонтактный;
					
					НомерТелефона = СокрЛП(КонтрСтрока.ContactPhone);
					Запись.Поле1 = Лев(НомерТелефона, 2);
					НомерТелефона = кмсфпУбратьИзНомераТелефонаВсеБуквы(НомерТелефона);
					Если СтрДлина(НомерТелефона) < 11 Тогда
						НоваяСтрока = ТаблицаОщибок.Добавить();
						НоваяСтрока.Код = "CVC05";
						НоваяСтрока.ТекстОшибки = "Номер телефона должен содержать не менее 11 цифр";
						RepairOrderChange = обПолучитьВозвратWAError("http://wa.dms.webservice/RepairOrderGetRequest",RepairOrderChangeRequest,RepairOrderChange,"-1",ТаблицаОщибок);
						Возврат RepairOrderChange;            
					КонецЕсли;
					НомерТелефона = Сред(НомерТелефона, 2, 10);
					Запись.Поле2 = Лев(НомерТелефона, 3);
					Запись.Поле3 = Сред(НомерТелефона, 4);
					Запись.Представление = Запись.Поле1 + ", " + Запись.Поле2 + Запись.Поле3;
					
					Попытка
						Запись.Записать(Истина);
					Исключение
						НоваяСтрока = ТаблицаОщибок.Добавить();
						НоваяСтрока.Код = "WA03";
						НоваяСтрока.ТекстОшибки = ОписаниеОшибки();
						RepairOrderChange = обПолучитьВозвратWAError("http://wa.dms.webservice/RepairOrderGetRequest",RepairOrderChangeRequest,RepairOrderChange,"-1",ТаблицаОщибок);
						Возврат RepairOrderChange;            
					КонецПопытки; 			
				КонецЕсли;
			КонецЕсли; 
		КонецЕсли;  			  		
	КонецЦикла;        	

	// Автомобиль \\
	Попытка
		DMSVehicleNo = RepairOrderChangeRequest.RepairOrderChange.Vehicle.DMSVehicleNo;  
	Исключение
		DMSVehicleNo = Неопределено;	
	КонецПопытки;    	

    Если DMSVehicleNo <> Неопределено Тогда // такого не должно быть!
		Если ЗначениеЗаполнено(DMSVehicleNo) Тогда
			АвтомобильСсылка = Справочники.Автомобили.НайтиПоКоду(DMSVehicleNo);
			Если ЗначениеЗаполнено(АвтомобильСсылка) Тогда			
				ЗаказНарядОбъект.Автомобиль = АвтомобильСсылка;
				ЗаказНарядОбъект.Пробег = Справочники.Автомобили.ЧтениеЗначенияРегистраСведения(АвтомобильСсылка, Перечисления.ДополнительнаяИнформацияАвтомобилей.Пробег, ТекущаяДата());
			Иначе
				НоваяСтрока = ТаблицаОщибок.Добавить();
				НоваяСтрока.Код = "WA03";
				НоваяСтрока.ТекстОшибки = "Неверный код автомобиля";
				RepairOrderChange = обПолучитьВозвратWAError("http://wa.dms.webservice/RepairOrderGetRequest",RepairOrderChangeRequest,RepairOrderChange,"-1",ТаблицаОщибок);
				Возврат RepairOrderChange;
			КонецЕсли;   			
       
		Иначе      
			НоваяСтрока = ТаблицаОщибок.Добавить();
			НоваяСтрока.Код = "WA03";
			НоваяСтрока.ТекстОшибки = "Не задан код автомобиля";
			RepairOrderChange = обПолучитьВозвратWAError("http://wa.dms.webservice/RepairOrderGetRequest",RepairOrderChangeRequest,RepairOrderChange,"-1",ТаблицаОщибок);
			Возврат RepairOrderChange;  
		КонецЕсли; 		
	Иначе
	КонецЕсли;      	
	
	// ТОВАРЫ И РАБОТЫ
	ТаблицаРабот = Новый ТаблицаЗначений;
	ТаблицаРабот.Колонки.Добавить("Code",		 		 Новый ОписаниеТипов("Строка"));
	ТаблицаРабот.Колонки.Добавить("EstimatedHours",		 Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(5,2)));
	ТаблицаРабот.Колонки.Добавить("Quantity",			 Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(5,2)));
	ТаблицаРабот.Колонки.Добавить("UnitPrice",	 		 Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(15,2)));
	ТаблицаРабот.Колонки.Добавить("TotalPrice",	 		 Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(15,2)));
	ТаблицаРабот.Колонки.Добавить("TotalPriceIncludeTax",Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(15,2)));
	ТаблицаРабот.Колонки.Добавить("Discount",			 Новый ОписаниеТипов("СправочникСсылка.ТипыСкидок"));  
	ТаблицаРабот.Колонки.Добавить("DiscountRate",	 	 Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(15,2)));
	
	ТаблицаТоваров = Новый ТаблицаЗначений;
	ТаблицаТоваров.Колонки.Добавить("PartNumber",		 	Новый ОписаниеТипов("Строка"));
	ТаблицаТоваров.Колонки.Добавить("Quantity",			 	Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(5,2)));
	ТаблицаТоваров.Колонки.Добавить("UnitPrice",	 		Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(15,2)));
	ТаблицаТоваров.Колонки.Добавить("TotalPrice",	 		Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(15,2)));
	ТаблицаТоваров.Колонки.Добавить("TotalPriceIncludeTax", Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(15,2)));
	ТаблицаТоваров.Колонки.Добавить("Discount",		 		Новый ОписаниеТипов("СправочникСсылка.ТипыСкидок"));
	ТаблицаТоваров.Колонки.Добавить("DiscountRate",	 		Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(15,2)));
	
	ТаблицаТоваровЗаказчика = Новый ТаблицаЗначений;
	ТаблицаТоваровЗаказчика.Колонки.Добавить("PartNumber",		 	Новый ОписаниеТипов("Строка"));
	ТаблицаТоваровЗаказчика.Колонки.Добавить("Quantity",			Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(5,2)));
	    	
	Попытка
		МассивОбщихПонятий = RepairOrderChangeRequest.RepairOrderChange.RequestItems; 		
	Исключение
		МассивОбщихПонятий = Неопределено;     		
	КонецПопытки;
	
	Если МассивОбщихПонятий = Неопределено Тогда
		ПроверкаУдаления = Ложь;
	Иначе
		ПроверкаУдаления = Истина;
	КонецЕсли;
	
	Если НЕ МассивОбщихПонятий = Неопределено Тогда
		Для Каждого ОбщееПонятие Из МассивОбщихПонятий.RequestItem Цикл
			Попытка 
				RequestCode = ОбщееПонятие.RequestCode;
			Исключение
				НоваяСтрока = ТаблицаОщибок.Добавить();
				НоваяСтрока.Код = "ROC12";
				НоваяСтрока.ТекстОшибки = "Отсутствует код пакета работ";
				RepairOrderChange = обПолучитьВозвратWAError("http://wa.dms.webservice/RepairOrderGetRequest",RepairOrderChangeRequest,RepairOrderChange,"-1",ТаблицаОщибок);
				Возврат RepairOrderChange;         
			КонецПопытки;
			Если RequestCode = "Request_OP" Тогда
				Попытка
					МассивРабот = ОбщееПонятие.OPCodes;  
				Исключение
					МассивРабот = Неопределено;
				КонецПопытки;
                Если НЕ МассивРабот = Неопределено Тогда
					Для Каждого СтрокаРабота Из МассивРабот.OpCode Цикл
						НоваяСтрокаРабота = ТаблицаРабот.Добавить();
						Попытка
							НоваяСтрокаРабота.Code = СтрокаРабота.Code;
						Исключение
							НоваяСтрока = ТаблицаОщибок.Добавить();
							НоваяСтрока.Код = "ROC16";
							НоваяСтрока.ТекстОшибки = "Отсутствует код работы";
							RepairOrderChange = обПолучитьВозвратWAError("http://wa.dms.webservice/RepairOrderGetRequest",RepairOrderChangeRequest,RepairOrderChange,"-1",ТаблицаОщибок);
							Возврат RepairOrderChange;  
						КонецПопытки;
						Если обЗначениеНеЗаполнено(НоваяСтрокаРабота.Code) Тогда
							НоваяСтрока = ТаблицаОщибок.Добавить();
							НоваяСтрока.Код = "ROC16";
							НоваяСтрока.ТекстОшибки = "Отсутствует код работы";
							RepairOrderChange = обПолучитьВозвратWAError("http://wa.dms.webservice/RepairOrderGetRequest",RepairOrderChangeRequest,RepairOrderChange,"-1",ТаблицаОщибок);
							Возврат RepairOrderChange;   
						КонецЕсли;
						Попытка
							НоваяСтрокаРабота.EstimatedHours = Число(СтрокаРабота.EstimatedHours); 	
						Исключение
						КонецПопытки;
                        Попытка
							НоваяСтрокаРабота.Quantity = Число(СтрокаРабота.Quantity); 	
						Исключение
						КонецПопытки;
                        Попытка
							НоваяСтрокаРабота.UnitPrice = Число(СтрокаРабота.PriceType.UnitPrice); 	
						Исключение
						КонецПопытки;
						Попытка
							НоваяСтрокаРабота.TotalPrice = Число(СтрокаРабота.PriceType.TotalPrice); 	
						Исключение
						КонецПопытки;
                        Попытка
							НоваяСтрокаРабота.TotalPriceIncludeTax = Число(СтрокаРабота.PriceType.TotalPriceIncludeTax); 	
						Исключение
						КонецПопытки;
						Попытка
							DiscountRate = Число(СтрокаРабота.PriceType.DiscountRate); 
							Если DiscountRate > 0 Тогда 
								Запрос = Новый Запрос;
								Запрос.Текст = "ВЫБРАТЬ
								               |	СкидкиСтрокиСрезПоследних.Скидка,
								               |	СкидкиСтрокиСрезПоследних.ЗначениеСкидки
								               |ИЗ
								               |	РегистрСведений.СкидкиСтроки.СрезПоследних(
								               |			,
								               |			ЗначениеСкидки = &ПроцентСкидки
								               |				И СкидкаНаРаботы = ИСТИНА
								               |				И РучнаяСкидка = ИСТИНА) КАК СкидкиСтрокиСрезПоследних
								               |
								               |УПОРЯДОЧИТЬ ПО
								               |	СкидкиСтрокиСрезПоследних.Период УБЫВ";   
											   
								Запрос.Параметры.Вставить("ПроцентСкидки",DiscountRate);
								ВыборкаСкидок = Запрос.Выполнить().Выбрать();
								Если ВыборкаСкидок.Количество()=0 Тогда  							
									НоваяСтрока = ТаблицаОщибок.Добавить();
									НоваяСтрока.Код = "WA03";
									НоваяСтрока.ТекстОшибки = "Незарегистрированный процент скидки на работы.";
									RepairOrderChange = обПолучитьВозвратWAError("http://wa.dms.webservice/RepairOrderGetRequest",RepairOrderChangeRequest,RepairOrderChange,"-1",ТаблицаОщибок);
									Возврат RepairOrderChange; 
								Иначе
									ВыборкаСкидок.Следующий();
									НоваяСтрокаРабота.Discount = ВыборкаСкидок.Скидка;
									НоваяСтрокаРабота.DiscountRate = ВыборкаСкидок.ЗначениеСкидки;        
								КонецЕсли;  
							КонецЕсли;   
						Исключение
						КонецПопытки;
                        Попытка
							НоваяСтрокаРабота.DiscountPrice = Число(СтрокаРабота.DiscountPrice); 	
						Исключение
						КонецПопытки;
					КонецЦикла;
				КонецЕсли;  					
			ИначеЕсли RequestCode = "Request_Part" Тогда     // OP_Part 				
				Попытка
					МассивРабот = ОбщееПонятие.OPCodes;  
				Исключение
					МассивРабот = Неопределено;
				КонецПопытки;
				Если НЕ МассивРабот = Неопределено Тогда
					Для Каждого СтрокаРабота Из МассивРабот.OpCode Цикл 
						Попытка
							Code = СтрокаРабота.Code;
						Исключение
							НоваяСтрока = ТаблицаОщибок.Добавить();
							НоваяСтрока.Код = "ROC16";
							НоваяСтрока.ТекстОшибки = "Отсутствует код работы OP_Part";
							RepairOrderChange = обПолучитьВозвратWAError("http://wa.dms.webservice/RepairOrderGetRequest",RepairOrderChangeRequest,RepairOrderChange,"-1",ТаблицаОщибок);
							Возврат RepairOrderChange; 
						КонецПопытки;
						Если Code = "OP_Part" Тогда  						
							Попытка
								МассивТоваров = СтрокаРабота.Parts;  
							Исключение
								МассивТоваров = Неопределено;
							КонецПопытки;
							Если НЕ МассивТоваров = Неопределено Тогда    							
								Для Каждого СтрокаНоменклатура Из МассивТоваров.Part Цикл
									НоваяСтрокаНоменклатура = ТаблицаТоваров.Добавить();
									Попытка
										НоваяСтрокаНоменклатура.PartNumber = СтрокаНоменклатура.PartNumber;
									Исключение
										НоваяСтрока = ТаблицаОщибок.Добавить();
										НоваяСтрока.Код = "ROC19";
										НоваяСтрока.ТекстОшибки = "Отсутствует код номенклатуры";
										RepairOrderChange = обПолучитьВозвратWAError("http://wa.dms.webservice/RepairOrderGetRequest",RepairOrderChangeRequest,RepairOrderChange,"-1",ТаблицаОщибок);
										Возврат RepairOrderChange;   
									КонецПопытки;
									Если обЗначениеНеЗаполнено(НоваяСтрокаНоменклатура.PartNumber) Тогда
										НоваяСтрока = ТаблицаОщибок.Добавить();
										НоваяСтрока.Код = "ROC19";
										НоваяСтрока.ТекстОшибки = "Отсутствует код номенклатуры";
										RepairOrderChange = обПолучитьВозвратWAError("http://wa.dms.webservice/RepairOrderGetRequest",RepairOrderChangeRequest,RepairOrderChange,"-1",ТаблицаОщибок);
										Возврат RepairOrderChange;    
									КонецЕсли;
	                                Попытка
										НоваяСтрокаНоменклатура.Quantity = Число(СтрокаНоменклатура.Quantity); 	
									Исключение
									КонецПопытки;
									Попытка
										НоваяСтрокаНоменклатура.UnitPrice = Число(СтрокаНоменклатура.PriceType.UnitPrice); 	
									Исключение
									КонецПопытки;  
									Попытка
										НоваяСтрокаНоменклатура.TotalPrice = Число(СтрокаНоменклатура.PriceType.TotalPrice); 	
									Исключение
									КонецПопытки;
			                        Попытка
										НоваяСтрокаНоменклатура.TotalPriceIncludeTax = Число(СтрокаНоменклатура.PriceType.TotalPriceIncludeTax); 	
									Исключение
									КонецПопытки; 
									Попытка
										DiscountRate = Число(СтрокаНоменклатура.PriceType.DiscountRate); 
										Если DiscountRate > 0 Тогда 
											Запрос = Новый Запрос;
											Запрос.Текст = "ВЫБРАТЬ
											               |	СкидкиСтрокиСрезПоследних.Скидка,
											               |	СкидкиСтрокиСрезПоследних.ЗначениеСкидки
											               |ИЗ
											               |	РегистрСведений.СкидкиСтроки.СрезПоследних(
											               |			,
											               |			ЗначениеСкидки = &ПроцентСкидки
											               |				И СкидкаНаТовары = ИСТИНА
											               |				И РучнаяСкидка = ИСТИНА) КАК СкидкиСтрокиСрезПоследних";
														   
											Запрос.Параметры.Вставить("ПроцентСкидки",DiscountRate);
											ВыборкаСкидок = Запрос.Выполнить().Выбрать();
											Если ВыборкаСкидок.Количество()=0 Тогда  							
												НоваяСтрока = ТаблицаОщибок.Добавить();
												НоваяСтрока.Код = "WA03";
												НоваяСтрока.ТекстОшибки = "Незарегистрированный процент скидки на работы.";
												RepairOrderChange = обПолучитьВозвратWAError("http://wa.dms.webservice/RepairOrderGetRequest",RepairOrderChangeRequest,RepairOrderChange,"-1",ТаблицаОщибок);
												Возврат RepairOrderChange;     
											Иначе
												ВыборкаСкидок.Следующий();
												НоваяСтрокаНоменклатура.Discount = ВыборкаСкидок.Скидка;
												НоваяСтрокаНоменклатура.DiscountRate = ВыборкаСкидок.ЗначениеСкидки;
											КонецЕсли;    
										КонецЕсли;

									Исключение
									КонецПопытки;
									Попытка
										НоваяСтрокаНоменклатура.DiscountPrice = Число(СтрокаНоменклатура.DiscountPrice); 	
									Исключение
									КонецПопытки;
								КонецЦикла;   							
	                        КонецЕсли;						
						Иначе 						
							НоваяСтрока = ТаблицаОщибок.Добавить();
							НоваяСтрока.Код = "ROC16";
							НоваяСтрока.ТекстОшибки = "Код работы не OP_Part";
							RepairOrderChange = обПолучитьВозвратWAError("http://wa.dms.webservice/RepairOrderGetRequest",RepairOrderChangeRequest,RepairOrderChange,"-1",ТаблицаОщибок);
							Возврат RepairOrderChange;   					
						КонецЕсли;
					КонецЦикла;
				КонецЕсли;
			Иначе
				НоваяСтрока = ТаблицаОщибок.Добавить();
				НоваяСтрока.Код = "ROC12";
				НоваяСтрока.ТекстОшибки = "Неверный код пакета работ";
				RepairOrderChange = обПолучитьВозвратWAError("http://wa.dms.webservice/RepairOrderGetRequest",RepairOrderChangeRequest,RepairOrderChange,"-1",ТаблицаОщибок);
				Возврат RepairOrderChange;  
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;	
	
	Попытка
		МассивДеталейЗаказчика = RepairOrderChangeRequest.RepairOrderChange.CustomerParts;  
	Исключение
		МассивДеталейЗаказчика = Неопределено;
	КонецПопытки;
	Если НЕ МассивДеталейЗаказчика = Неопределено Тогда    							
		Для Каждого СтрокаНоменклатура Из МассивДеталейЗаказчика.CustomerPart Цикл
			НоваяСтрокаНоменклатура = ТаблицаТоваровЗаказчика.Добавить();
			Попытка
				НоваяСтрокаНоменклатура.PartNumber = СтрокаНоменклатура.PartNumber;
			Исключение
				НоваяСтрока = ТаблицаОщибок.Добавить();
				НоваяСтрока.Код = "ROC19";
				НоваяСтрока.ТекстОшибки = "Отсутствует код номенклатуры в деталях заказчика";
				RepairOrderChange = обПолучитьВозвратWAError("http://wa.dms.webservice/RepairOrderGetRequest",RepairOrderChangeRequest,RepairOrderChange,"-1",ТаблицаОщибок);
				Возврат RepairOrderChange;               
			КонецПопытки;
			Если обЗначениеНеЗаполнено(НоваяСтрокаНоменклатура.PartNumber) Тогда
				НоваяСтрока = ТаблицаОщибок.Добавить();
				НоваяСтрока.Код = "ROC19";
				НоваяСтрока.ТекстОшибки = "Отсутствует код номенклатуры в деталях заказчика";
				RepairOrderChange = обПолучитьВозвратWAError("http://wa.dms.webservice/RepairOrderGetRequest",RepairOrderChangeRequest,RepairOrderChange,"-1",ТаблицаОщибок);
				Возврат RepairOrderChange;
			КонецЕсли;
            Попытка
				НоваяСтрокаНоменклатура.Quantity = Число(СтрокаНоменклатура.Quantity); 	
			Исключение
			КонецПопытки;
		КонецЦикла;   							
	КонецЕсли;	
	
	СтараяТаблицаРабот = ЗаказНарядОбъект.Работы.Выгрузить(,"Работа");
		
	// ПОДСТАНОВКА РАБОТ И ЗАПЧАСТЕЙ ///////////////
	Для Каждого СтрокаРаботы Из ТаблицаРабот Цикл
		РаботаСсылка = Справочники.Автоработы.НайтиПоКоду(СтрокаРаботы.Code);
		Если РаботаСсылка = Справочники.Автоработы.ПустаяСсылка() Тогда
			НоваяСтрока = ТаблицаОщибок.Добавить();
			НоваяСтрока.Код = "ROC16";
			НоваяСтрока.ТекстОшибки = "Не могу найти работу по коду "+СтрокаРаботы.Code;
			RepairOrderChange = обПолучитьВозвратWAError("http://wa.dms.webservice/RepairOrderGetRequest",RepairOrderChangeRequest,RepairOrderChange,"-1",ТаблицаОщибок);
			Возврат RepairOrderChange;             
		Иначе
			СтрокаВЗаявке = ЗаказНарядОбъект.Работы.Найти(РаботаСсылка, "Работа");
			Если СтрокаВЗаявке = Неопределено Тогда
				СтрокаВЗаявке = ЗаказНарядОбъект.Работы.Добавить();
				//СтрокаВЗаявке.флДоп = Истина;
				СтрокаВЗаявке.Основная = Ложь;
				
				СтрокаВЗаявке.Работа = РаботаСсылка;
				СтрокаВЗаявке.ИдентификаторРаботы = Новый УникальныйИдентификатор;
				ЗаказНарядОбъект.ОбработкаРеквизита("Работы.Работа",СтрокаВЗаявке);    				
			Иначе
				СтрокаВоВременнойТаблице = СтараяТаблицаРабот.Найти(РаботаСсылка, "Работа");
				СтараяТаблицаРабот.Удалить(СтрокаВоВременнойТаблице);
			КонецЕсли;
			Если СтрокаРаботы.EstimatedHours > 0 Тогда
				СтрокаВЗаявке.Коэффициент = СтрокаРаботы.EstimatedHours;
				ЗаказНарядОбъект.ОбработкаРеквизита("Работы.Коэффициент",СтрокаВЗаявке); 
			КонецЕсли;
			Если СтрокаРаботы.Quantity > 0 Тогда
				СтрокаВЗаявке.Количество = СтрокаРаботы.Quantity;
				ЗаказНарядОбъект.ОбработкаРеквизита("Работы.Количество",СтрокаВЗаявке); 
			КонецЕсли;
			//Если СтрокаРаботы.UnitPrice > 0 Тогда
			//	СтрокаВЗаявке.Сумма = СтрокаРаботы.UnitPrice;
			//	ЗаказНарядОбъект.ОбработкаРеквизита("Работы.Цена",СтрокаВЗаявке); 
			//КонецЕсли;
			//Если СтрокаРаботы.TotalPriceIncludeTax > 0 Тогда
			//	СтрокаВЗаявке.СуммаВсего = СтрокаРаботы.TotalPriceIncludeTax;
			//	ЗаказНарядОбъект.ОбработкаРеквизита("Работы.СуммаВсего",СтрокаВЗаявке); 
			//КонецЕсли;     
			//Если СтрокаРаботы.TotalPrice > 0 Тогда
			//	СтрокаВЗаявке.СуммаВсего = СтрокаРаботы.TotalPrice;
			//	ЗаказНарядОбъект.ОбработкаРеквизита("Работы.СуммаВсего",СтрокаВЗаявке); 
			//КонецЕсли;  
			Если СтрокаРаботы.Discount <> Справочники.ТипыСкидок.ПустаяСсылка() И СтрокаРаботы.DiscountRate<>СтрокаВЗаявке.ПроцентСкидки Тогда
				СтрокаВЗаявке.ПроцентСкидки = 0; 
				СтрокаВЗаявке.СкидкаНаТовар = СтрокаРаботы.Discount;
				ЗаказНарядОбъект.ОбработкаРеквизита("Работы.Количество",СтрокаВЗаявке);   			
			КонецЕсли;	 
		КонецЕсли;   		
	КонецЦикла;	
	
	СтараяТаблицаЗапчастей = ЗаказНарядОбъект.Товары.Выгрузить(,"Номенклатура");
	
	Для Каждого СтрокаНоменклатура Из ТаблицаТоваровЗаказчика Цикл
		НомСсылка = Справочники.Номенклатура.НайтиПоРеквизиту("Артикул",СтрокаНоменклатура.PartNumber);
		Если НомСсылка = Справочники.Номенклатура.ПустаяСсылка() Тогда
			НоваяСтрока = ТаблицаОщибок.Добавить();
			НоваяСтрока.Код = "ROC19";
			НоваяСтрока.ТекстОшибки = "Не могу найти номенклатуру заказчика по коду "+СтрокаНоменклатура.PartNumber;
			RepairOrderChange = обПолучитьВозвратWAError("http://wa.dms.webservice/RepairOrderGetRequest",RepairOrderChangeRequest,RepairOrderChange,"-1",ТаблицаОщибок);
			Возврат RepairOrderChange;           	
		Иначе
			СтрокаВЗаявке = ЗаказНарядОбъект.МатериалыЗаказчика.Найти(НомСсылка, "Номенклатура");
			Если СтрокаВЗаявке = Неопределено Тогда
				СтрокаВЗаявке = ЗаказНарядОбъект.Товары.Добавить();
				//СтрокаВЗаявке.флДоп = Истина;
				СтрокаВЗаявке.Номенклатура = НомСсылка;
				//СтрокаВЗаявке.Источник = Перечисления.ЗаказНарядНоменклатураИсточник.ДетальСоСклада;
				ЗаказНарядОбъект.ОбработкаРеквизита("Товары.Номенклатура",СтрокаВЗаявке);
				СтрокаВЗаявке.СкладКомпании = Справочники.СкладыКомпании.ОсновнойСкладКомпании;  
				//ЗаказНарядОбъект.ОбработкаРеквизита("Товары.СтавкаНДС",СтрокаВЗаявке); 
			Иначе
				СтрокаВоВременнойТаблице = СтараяТаблицаЗапчастей.Найти(НомСсылка, "Номенклатура");
				СтараяТаблицаЗапчастей.Удалить(СтрокаВоВременнойТаблице);
			КонецЕсли;
			Если СтрокаНоменклатура.Quantity > 0 Тогда
				СтрокаВЗаявке.Количество = СтрокаНоменклатура.Quantity;
				ЗаказНарядОбъект.ОбработкаРеквизита("Товары.Количество",СтрокаВЗаявке); 
				//ЗаказНарядОбъект.ОбработкаРеквизита("Товары.СтавкаНДС",СтрокаВЗаявке);  
			КонецЕсли;
		КонецЕсли;  
	КонецЦикла;	
	
	Для Каждого СтрокаНоменклатура Из ТаблицаТоваров Цикл
		НомСсылка = Справочники.Номенклатура.НайтиПоРеквизиту("Артикул",СтрокаНоменклатура.PartNumber);
		Если НомСсылка = Справочники.Номенклатура.ПустаяСсылка() Тогда
			НоваяСтрока = ТаблицаОщибок.Добавить();
			НоваяСтрока.Код = "ROC19";
			НоваяСтрока.ТекстОшибки = "Не могу найти номенклатуру заказчика по коду "+СтрокаНоменклатура.PartNumber;
			RepairOrderChange = обПолучитьВозвратWAError("http://wa.dms.webservice/RepairOrderGetRequest",RepairOrderChangeRequest,RepairOrderChange,"-1",ТаблицаОщибок);
			Возврат RepairOrderChange;   	
		Иначе
			СтрокаВЗаявке = ЗаказНарядОбъект.Товары.Найти(НомСсылка, "Номенклатура");
			Если СтрокаВЗаявке = Неопределено Тогда
				СтрокаВЗаявке = ЗаказНарядОбъект.Товары.Добавить();
				//СтрокаВЗаявке.флДоп = Истина;
				СтрокаВЗаявке.Основная = Истина;
				СтрокаВЗаявке.Номенклатура = НомСсылка;
				//СтрокаВЗаявке.Источник = Перечисления.ЗаказНарядНоменклатураИсточник.ДетальСоСклада;
				ЗаказНарядОбъект.ОбработкаРеквизита("Товары.Номенклатура", СтрокаВЗаявке);
				//СтрокаВЗаявке.СкладКомпании = Справочники.СкладыКомпании.ОсновнойСкладКомпании;  
				ЗаказНарядОбъект.ОбработкаРеквизита("Товары.СтавкаНДС", СтрокаВЗаявке);   
			Иначе
				СтрокаВоВременнойТаблице = СтараяТаблицаЗапчастей.Найти(НомСсылка, "Номенклатура");
				СтараяТаблицаЗапчастей.Удалить(СтрокаВоВременнойТаблице);
			КонецЕсли;
			Если СтрокаНоменклатура.Quantity > 0 Тогда
				СтрокаВЗаявке.Количество = СтрокаНоменклатура.Quantity;
				ЗаказНарядОбъект.ОбработкаРеквизита("Товары.Количество",СтрокаВЗаявке); 
			КонецЕсли;
			//Если СтрокаНоменклатура.UnitPrice > 0 Тогда
			//	СтрокаВЗаявке.Сумма = СтрокаНоменклатура.UnitPrice;
			//	ЗаказНарядОбъект.ОбработкаРеквизита("Товары.Сумма",СтрокаВЗаявке); 
			//КонецЕсли;
			//Если СтрокаНоменклатура.TotalPriceIncludeTax > 0 Тогда
			//	СтрокаВЗаявке.СуммаВсего = СтрокаНоменклатура.TotalPriceIncludeTax;
			//	ЗаказНарядОбъект.ОбработкаРеквизита("Товары.СуммаВсего",СтрокаВЗаявке); 
			//КонецЕсли;     
			//Если СтрокаНоменклатура.TotalPrice > 0 Тогда
			//	СтрокаВЗаявке.СуммаВсего = СтрокаНоменклатура.TotalPrice;
			//	ЗаказНарядОбъект.ОбработкаРеквизита("Товары.СуммаВсего",СтрокаВЗаявке); 
			//КонецЕсли;  
			Если СтрокаНоменклатура.Discount <> Справочники.ТипыСкидок.ПустаяСсылка() И СтрокаНоменклатура.DiscountRate<>СтрокаВЗаявке.ПроцентСкидки Тогда
				СтрокаВЗаявке.ПроцентСкидки = 0;
				СтрокаВЗаявке.СкидкаНаТовар = СтрокаНоменклатура.Discount;
				
				ОбработкаРасчетСкидок = ЗаказНарядОбъект["ОбработкаРасчетСкидок"];

				ОбработкаРасчетСкидок.ПодобратьСтрочнуюСкидку(ЗаказНарядОбъект, СтрокаВЗаявке);
				СтрокаВЗаявке.СкидкаНаТовар  = ОбработкаРасчетСкидок.ТекущаяСкидкаСтроки;
				СтрокаВЗаявке.ПроцентСкидкиСтроки = ОбработкаРасчетСкидок.ТекущийПроцентСкидкиСтроки;
				СтрокаВЗаявке.СуммаСкидкиСтроки = ОбработкаРасчетСкидок.ТекущаяСуммаСкидкиСтроки;

				СуммаИтого = 0;				
				СуммаИтого = ЗаказНарядОбъект.Товары.Итог("СуммаСкидки");
				СуммаИтого = СуммаИтого + ЗаказНарядОбъект.Товары.Итог("СуммаСкидкиСтроки");
				
				ЗаказНарядОбъект.СуммаСкидкиНаценки = СуммаИтого;
				ЗаказНарядОбъект.ОбработкаРеквизита("Товары.СтавкаНДС", СтрокаВЗаявке);					
			КонецЕсли;	 
		КонецЕсли;  
	КонецЦикла;	
	
	// удаляем оставшиеся работы и запчасти
	Если ПроверкаУдаления Тогда
		Для Каждого УдСтрока Из СтараяТаблицаРабот Цикл
			СтрокаВТаблице = ЗаказНарядОбъект.Работы.Найти(УдСтрока.Работа, "Работа");
			СтрокаИсполнителей = ЗаказНарядОбъект.Исполнители.Найти(СтрокаВТаблице.ИдентификаторРаботы, "ИдентификаторРаботы");
			Если Не СтрокаИсполнителей = Неопределено Тогда
	        	ЗаказНарядОбъект.Исполнители.Удалить(СтрокаИсполнителей);
			КонецЕсли;
			ЗаказНарядОбъект.Работы.Удалить(СтрокаВТаблице);   	
		КонецЦикла;  	
		Для Каждого УдСтрока Из СтараяТаблицаЗапчастей Цикл
			СтрокаВТаблице = ЗаказНарядОбъект.Товары.Найти(УдСтрока.Номенклатура, "Номенклатура");
			ЗаказНарядОбъект.Товары.Удалить(СтрокаВТаблице);   	
		КонецЦикла;
	КонецЕсли;
	
	//Если ПризнакVHC Тогда
	//	ЗанестиРезультатыКруговогоОсмотра(ЗаказНарядСсылка,ЗаказНарядСсылка.ДокументОснование);
	//	//Если НЕ ЗаказНарядСсылка2 = Документы.ЗаказНаряд.ПустаяСсылка() Тогда ЗанестиРезультатыКруговогоОсмотра(ЗаказНарядСсылка2,ЗаказНарядСсылка2.ДокументОснование); КонецЕсли;
	//КонецЕсли;
	
	Если ЗаказчикФизЛицо И ЗаказНарядОбъект.ВидРемонта.ГарантияЗавода И ЗаказНарядОбъект.Заказчик.СогласиеНаОбработкуПерсональныхДанных <> Перечисления.ВариантыОтветов.Да Тогда
    	НоваяСтрока = ТаблицаОщибок.Добавить();
		НоваяСтрока.Код = "ROC31";
		НоваяСтрока.ТекстОшибки = "Внимание! Клиент не дал согласие на обработку персональных данных! Нет прав работать с гарантийным заказ-нарядом.";
		RepairOrderChange = обПолучитьВозвратWAError("http://wa.dms.webservice/RepairOrderGetRequest",RepairOrderChangeRequest,RepairOrderChange,"-1",ТаблицаОщибок);
		Возврат RepairOrderChange;       
	КонецЕсли;      
	
	Попытка
		ЗаказНарядОбъект.ОбменДанными.Загрузка = Истина;
		ЗаказНарядОбъект.Записать();
	Исключение
		НоваяСтрока = ТаблицаОщибок.Добавить();
		НоваяСтрока.Код = "WA03";
		НоваяСтрока.ТекстОшибки = ОписаниеОшибки();
		RepairOrderChange = обПолучитьВозвратWAError("http://wa.dms.webservice/RepairOrderGetRequest",RepairOrderChangeRequest,RepairOrderChange,"-1",ТаблицаОщибок);
		Возврат RepairOrderChange;        
	КонецПопытки;  
	
	RepairOrderChange = обПолучитьВозвратWAError("http://wa.dms.webservice/RepairOrderGetRequest",RepairOrderChangeRequest,RepairOrderChange,"1",ТаблицаОщибок,Строка(ЗаказНарядОбъект.Ссылка.УникальныйИдентификатор()));
	Возврат RepairOrderChange;       

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

Функция ПолучитьКодПакетаТО(Автомобиль, НомерТО)
	мзКодыПакетовТО = РегистрыСведений.КодыПакетовТО.СоздатьМенеджерЗаписи();
	КодМодели = Автомобиль.Модель.КодМодели;
	Если ЗначениеЗаполнено(КодМодели) Тогда
		мзКодыПакетовТО.КодМодели = КодМодели;
	Иначе
		Возврат "";
	КонецЕсли;	
	мзКодыПакетовТО.НомерТО = НомерТО;
		
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
		мзКодыПакетовТО.НомерТО = НомерТО;
		мзКодыПакетовТО.ТипДвигателя = ТипДвигателя + "t";
		мзКодыПакетовТО.Прочитать();
		Если мзКодыПакетовТО.Выбран() Тогда
			Возврат мзКодыПакетовТО.КодПакетаТО;
		Иначе
			Возврат "";
		КонецЕсли;
	КонецЕсли;	
КонецФункции
                                       
