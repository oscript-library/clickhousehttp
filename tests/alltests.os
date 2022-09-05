#Использовать asserts
#Использовать ".."

Функция ПараметрыПодключения()
	Возврат Новый Структура("Хост, Порт, Логин, Пароль", "localhost", 8123, "username","passwd123");
КонецФункции

Процедура ПередЗапускомТеста() Экспорт
КонецПроцедуры

Процедура ПослеЗапускаТеста() Экспорт
КонецПроцедуры

Функция ПолучитьКоннектор()
	ПараметрыПодключения = ПараметрыПодключения();
	Коннектор = Новый КоннекторКликХаус(ПараметрыПодключения.Хост, ПараметрыПодключения.Порт, 
										ПараметрыПодключения.Логин, ПараметрыПодключения.Пароль);

	Возврат Коннектор;		
КонецФункции

Функция КолонкиТаблицы()
	Возврат "String,Date,Bool,Dec";
КонецФункции

Функция ПолучитьТестовуюТаблицу()
	ТЗ = Новый ТаблицаЗначений();
	Для каждого Колонка Из СтрРазделить(КолонкиТаблицы(), ",") Цикл
		ТЗ.Колонки.Добавить(Колонка);	
	КонецЦикла;

	НоваяСтрока = ТЗ.Добавить();
	НоваяСтрока.String = "Привет строка 1";
	НоваяСтрока.Date = ТекущаяДата();
	НоваяСтрока.Bool = Истина;
	НоваяСтрока.Dec = 1.2;

	НоваяСтрока = ТЗ.Добавить();
	НоваяСтрока.String = "Привет строка 2";
	НоваяСтрока.Date = ТекущаяДата() - 86400;
	НоваяСтрока.Bool = Ложь;
	НоваяСтрока.Dec = 15 / 2;
	
	Возврат ТЗ;
КонецФункции

Функция ИмяТестовойТаблицы()
	Возврат "choscript_test_table";
КонецФункции

Функция ПолучитьСписокТестов(ЮнитТестирование) Экспорт

    ВсеТесты = Новый Массив;    
    ВсеТесты.Добавить("ТестДолжен_ПроверитьСозданиеТаблицы");
	ВсеТесты.Добавить("ТестДолжен_ПроверитьОтправкуТЗ");
	ВсеТесты.Добавить("ТестДолжен_ПроверитьУдалениеТаблицы");
	ВсеТесты.Добавить("ТестДолжен_ПроверитьВыборкуВТЗ");
	ВсеТесты.Добавить("ТестДолжен_ПроверитьПроизвольныйЗапрос");
	
    Возврат ВсеТесты;

КонецФункции

Процедура ТестДолжен_ПроверитьСозданиеТаблицы() Экспорт

	ТестоваяТаблица = ПолучитьТестовуюТаблицу();
	Коннектор = ПолучитьКоннектор();
	ИмяТаблицы = ИмяТестовойТаблицы();
	ОписаниеКолонок = Коннектор.ПолучитьОписаниеКолонок(ТестоваяТаблица.Колонки);

  	Результат = Коннектор.СоздатьТаблицу(ИмяТаблицы, ОписаниеКолонок);

	Ожидаем.Что(Результат.Ошибка, "Таблица создана без ошибок").Равно(Ложь);
	
КонецПроцедуры

Процедура ТестДолжен_ПроверитьОтправкуТЗ() Экспорт

	ТестоваяТаблица = ПолучитьТестовуюТаблицу();
	Коннектор = ПолучитьКоннектор();
	ИмяТаблицы = ИмяТестовойТаблицы();
	
  	Результат = Коннектор.ОтправитьТаблицуЗначенийВКХ(ИмяТаблицы, ТестоваяТаблица);

	Ожидаем.Что(Результат.Ошибка, "Таблица значений отправлена").Равно(Ложь);
	
КонецПроцедуры

Процедура ТестДолжен_ПроверитьУдалениеТаблицы() Экспорт

	Коннектор = ПолучитьКоннектор();
	ИмяТаблицы = ИмяТестовойТаблицы();
	
  	Результат = Коннектор.УдалитьТаблицу(ИмяТаблицы);

	Ожидаем.Что(Результат.Ошибка, "Таблица удалена").Равно(Ложь);
	
КонецПроцедуры

Процедура ТестДолжен_ПроверитьВыборкуВТЗ() Экспорт

	ТестоваяТаблица = ПолучитьТестовуюТаблицу();
	Коннектор = ПолучитьКоннектор();
	ИмяТаблицы = ИмяТестовойТаблицы();
	
  	Коннектор.УдалитьТаблицу(ИмяТаблицы);
	Коннектор.ОтправитьТаблицуЗначенийВКХ(ИмяТаблицы, ТестоваяТаблица);
	ТЗРезультат = Коннектор.ВыбратьВТаблицуЗначений(ИмяТаблицы, КолонкиТаблицы());

	Ожидаем.Что(ТипЗнч(ТЗРезультат) = Тип("ТаблицаЗначений"), "Получили тип ТаблицаЗначений").Равно(Истина);
	Ожидаем.Что(ТЗРезультат.Количество() = 0, "Таблица не пустая").Равно(Ложь);
	
КонецПроцедуры

Процедура ТестДолжен_ПроверитьПроизвольныйЗапрос() Экспорт

	Коннектор = ПолучитьКоннектор();
	ИмяТаблицы = ИмяТестовойТаблицы();
	ТекстЗапроса = СтрШаблон("SELECT * FROM %1", ИмяТаблицы);
	
  	Результат = Коннектор.ВыполнитьЗапросВКликХаус(ТекстЗапроса);

	Ожидаем.Что(Результат.Ошибка, "Произвольный запрос выполнен").Равно(Ложь);
	
КонецПроцедуры