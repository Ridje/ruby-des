ruby-des
========
Назначение программы:
Программа предназначена для шифрования и дешифрования текстовых сообщений с использованием алгоритма шифрования DES. Доступные методы шифрования: DES ECB, DES CBC, DES EEE2, DES EEE3, DES EDE2, DES EDE3
Используемые технические средства:
ОС – Windows 7/Ubuntu 13.04
IDE – Aptana Studio with Plugin RadRails(Win)/ Sublime Text 2(Ubuntu)
Язык разработки:Ruby 1.9.1
Технические требования к запуску
64 мб ОЗУ
20 кб свободного места на жестком диске
Процессор Intel Celeron++
Входные и выходные данные
  Входными данными программы являются шифруемое сообщение и ключ.
  Выходные данные – зашифрованное и расшифрованное текстовое сообщение.
Ввод в действие программного продукта
	Необходимо через командную строку запустить файл new_file.rb. Например, для запуска на Ubuntu 13.04 из папки Documents необходимо зажать Cntrl+Alt+T, в появившемся окне ввести cd ~/Documents. Нажать Enter. Затем ввести ruby new_file.rb. 
  Терминал подгрузит программу. Далее следовать инструкциям. Программа предлагает работу в виде командной строки, почти все действия выполняются автоматически. Необходимо только ввести текст сообщения, который вы хотите зашифровать. 
  Программа предложит ввести ключ, который будет использоваться для всех алгоритмов шифрования, где он еще не предусмотрен. На формат ключа наложено ограничение в 8 символов. 
  Если формат будет не соблюден, программа рвет свою работу. После ввода нажмите Enter. 
 
Далее необходимо ввести сообщение для шифрования. Программных ограничений на количество символов не стоит. Программа некорректно работает с кириллицей.
 
После ввода шифруемого сообщения, программа зашифрует и расшифрует его при помощи алгоритма DES CBC. После выведет ключ в виде битов и подключи. Затем программа запросит сообщение, которое необходимо зашифровать алгоритмами DES EBC и Triple DES.
 
Программа последовательно выведет этапы шифрования и расшифровывания введенного сообщения. Затем программа автоматически прекращает работу.

Дохрена украл с другого гитхаба, в основном это выполнение s-box части шифрования.
