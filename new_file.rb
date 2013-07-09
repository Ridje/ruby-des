class Integer
  # конвертирует целоое число в 4-битовый массив, используемый s-box
  def to_bits
    [self>>3, (self>>2)&1, (self>>1)&1, self&1] #?????
  end
end
class String
  def pad
    self + " "
end
  def to_bytes #переводит символы в байты
    bitarr = []
    self.split("").each do |x|
      bitarr<<x.unpack('b*').join
    end
    bitarr = bitarr.join
  end
  def to_bits #переводит байты в биты
    bitarr=[]
    self.each_char{|c| bitarr << c.to_i if c=='0' || c=='1'|| c==' '}
    bitarr
  end
end
class Array 
  def norm_vid
    bitarr = []
    self.each{|x| x.each{|b| bitarr<<b}}
    bitarr
  end
  def add_byte
    bitarr = []
    ubitarr = []
    self.each_with_index{|bit, i| ubitarr<<bit; ubitarr.service_with_byte if (i+1)%7==0; bitarr<<ubitarr if (i+1)%7==0; ubitarr=[] if (i+1)%7==0}
    bitarr
  end
  def service_with_byte
    sum = 0
    self.each{|bit| sum+=bit }
    sum%2==0? self.push(0):self.push(1)
    #if sum%2==0 then
      #self.push(0)
    #else
      #self.push(1)
    #end
  end
  def split8
    bitarr = []
    s=""
    temp = 0
    self.each_with_index{|bit,i| s+=bit.to_s; bitarr<<s if(i+1)%64==0; s = "" if (i+1)%64==0; s+="0" if self.length-temp<64; puts s}
    bitarr
  end
  def left(n) #метод переноса массива на n знаков влево
      self[n,self.length] + self[0,n]
  end
  def to_words_16
    bitarr = []
    bitarr<<self.pack('b*b*b*b*b*b*b*b*b*b*b*b*b*b*b*b*')
    bitarr
  end
  def to_words
    bitarr = []
    bitarr<<self.pack('b*b*b*b*b*b*b*b*')
    bitarr
  end
  def to_string
    bitarr = []
    s = ""
    self.each_with_index{|bit,i| s+=bit.to_s; bitarr<<s if (i+1)%8==0; s = "" if (i+1)%8==0}
    bitarr = bitarr.to_words
    bitarr = bitarr.pretty
  end
  def to_string_16
    bitarr = []
    s = ""
    self.each_with_index{|bit,i| s+=bit.to_s; bitarr<<s if (i+1)%8==0; s = "" if (i+1)%8==0}
    bitarr = bitarr.to_words_16
    bitarr = bitarr.pretty
  end
  def pretty(n=8) #разбивает массив в красиво сгрупированную строку
    s = ""
    self.each_with_index{|bit,i| s+=bit.to_s; s+=' ' if (i+1)%n==0}
    s
  end
  def perm(table) #побитово перестанавливает текущий массив
    table.split(' ').map{|bit| self[bit.to_i-1]}
  end
  def pc1 #обеспечивает перестановку PC1, берет оригинальный 64-битовый ключ и возвращает 56-битовую перестановку
    perm "
      57   49    41   33    25    17    9
       1   58    50   42    34    26   18
      10    2    59   51    43    35   27
      19   11     3   60    52    44   36
      63   55    47   39    31    23   15
       7   62    54   46    38    30   22
      14    6    61   53    45    37   29
      21   13     5   28    20    12    4 "
  end
  def pc2 # перестановка PC2, берет CDN и производит 48 битовый Kn
    perm "
      14    17   11    24     1    5
       3    28   15     6    21   10
      23    19   12     4    26    8
      16     7   27    20    13    2
      41    52   31    37    47   55
      30    40   51    45    33   48
      44    49   39    56    34   53
      46    42   50    36    29   32"
  end
  def ip #перестановка IP, принимает 64 битовый массив и возвращает 64 битовый
    perm "
      58    50   42    34    26   18    10    2
      60    52   44    36    28   20    12    4
      62    54   46    38    30   22    14    6
      64    56   48    40    32   24    16    8
      57    49   41    33    25   17     9    1
      59    51   43    35    27   19    11    3
      61    53   45    37    29   21    13    5
      63    55   47    39    31   23    15    7"
  end
  def xor(b) #побитово складывает принимаемый и вызывающий массив
    i=0
    self.map{|a| i+=1; a^b[i-1]}
  end
  def split #делит массив на 2 части
    [self[0,self.length/2], self[self.length/2, self.length/2]]
  end
  def split_3
    [self[0, self.length/3], self[self.length/3, self.length/3], self[self.length/3+self.length/3, self.length/3]]
  end
  def split6 #делит на 6-битовые массивы
    arr=[]
    subarr=[]
    self.each{|a|
      subarr<<a
      if subarr.length==6
        arr<<subarr
        subarr=[]
      end
    }
    arr
  end

  def e_bits #на входе 32 битовые, на выходе 48, перестановка используется первым этапом в F функции
    perm "
      32     1    2     3     4    5
       4     5    6     7     8    9
       8     9   10    11    12   13
      12    13   14    15    16   17
      16    17   18    19    20   21
      20    21   22    23    24   25
      24    25   26    27    28   29
      28    29   30    31    32    1"

  end
  def s_box(b) 
    #b это номер таблицы
    s_tables = "
                             S1
     14  4  13  1   2 15  11  8   3 10   6 12   5  9   0  7
      0 15   7  4  14  2  13  1  10  6  12 11   9  5   3  8
      4  1  14  8  13  6   2 11  15 12   9  7   3 10   5  0
     15 12   8  2   4  9   1  7   5 11   3 14  10  0   6 13
                             S2
     15  1   8 14   6 11   3  4   9  7   2 13  12  0   5 10
      3 13   4  7  15  2   8 14  12  0   1 10   6  9  11  5
      0 14   7 11  10  4  13  1   5  8  12  6   9  3   2 15
     13  8  10  1   3 15   4  2  11  6   7 12   0  5  14  9
                             S3
     10  0   9 14   6  3  15  5   1 13  12  7  11  4   2  8
     13  7   0  9   3  4   6 10   2  8   5 14  12 11  15  1
     13  6   4  9   8 15   3  0  11  1   2 12   5 10  14  7
      1 10  13  0   6  9   8  7   4 15  14  3  11  5   2 12
                             S4
      7 13  14  3   0  6   9 10   1  2   8  5  11 12   4 15
     13  8  11  5   6 15   0  3   4  7   2 12   1 10  14  9
     10  6   9  0  12 11   7 13  15  1   3 14   5  2   8  4
      3 15   0  6  10  1  13  8   9  4   5 11  12  7   2 14
                             S5
      2 12   4  1   7 10  11  6   8  5   3 15  13  0  14  9
     14 11   2 12   4  7  13  1   5  0  15 10   3  9   8  6
      4  2   1 11  10 13   7  8  15  9  12  5   6  3   0 14
     11  8  12  7   1 14   2 13   6 15   0  9  10  4   5  3
                             S6
     12  1  10 15   9  2   6  8   0 13   3  4  14  7   5 11
     10 15   4  2   7 12   9  5   6  1  13 14   0 11   3  8
      9 14  15  5   2  8  12  3   7  0   4 10   1 13  11  6
      4  3   2 12   9  5  15 10  11 14   1  7   6  0   8 13
                             S7
      4 11   2 14  15  0   8 13   3 12   9  7   5 10   6  1
     13  0  11  7   4  9   1 10  14  3   5 12   2 15   8  6
      1  4  11 13  12  3   7 14  10 15   6  8   0  5   9  2
      6 11  13  8   1  4  10  7   9  5   0 15  14  2   3 12
                             S8
     13  2   8  4   6 15  11  1  10  9   3 14   5  0  12  7
      1 15  13  8  10  3   7  4  12  5   6 11   0 14   9  2
      7 11   4  1   9 12  14  2   0  6  10 13  15  3   5  8
      2  1  14  7   4 10   8 13  15 12   9  0   3  5   6 11
      "
    # Находит только необходимую ему таблицу
    s_table = s_tables[s_tables.index('S%d'%b)+3,999]
    s_table = s_table[0,s_table.index('S')] if s_table.index('S')
    s_table = s_table.split(' ')   # КОнвертирует текст в удобный вид
    row = self.first*2 + self.last # строка высчитывается из первого и последнего битов
    col = self[1]*8 + self[2]*4 + self[3]*2 + self[4] # колонка высчитывается из серединных 4-ых битов
    s_table[row*16+col].to_i.to_bits 
  end
  def perm_p #32 на входе, 32 на выходе
    perm "
      16   7  20  21
      29  12  28  17
       1  15  23  26
       5  18  31  10
       2   8  24  14
      32  27   3   9
      19  13  30   6
      22  11   4  25"
  end
  def ip_inverse #последняя перестановка 64 на входе, 64 на выходе
    perm "
      40     8   48    16    56   24    64   32
      39     7   47    15    55   23    63   31
      38     6   46    14    54   22    62   30
      37     5   45    13    53   21    61   29
      36     4   44    12    52   20    60   28
      35     3   43    11    51   19    59   27
      34     2   42    10    50   18    58   26
      33     1   41     9    49   17    57   25"
  end
end

def expand(k) #переставляет 64-битовый ключ в 56-битовый
  kplus = k.pc1 #вызывает метод, отсеивающий 8 бит и возвращающий K+
  c0,d0 = kplus.split # делит K+ на две части, старшую C0 и младшую D0
  cdn = shifts(c0, d0) #делает перестановки, дающие нам cdn
  cdn.map{|cd| cd.pc2} #для каждого cdn, пропускает его через метод PC2, возвращая Kn
end

def shifts(c0,d0) #делаем сдвиги ключа
    cn, dn = [c0], [d0]
  # схема сдвига
  [1,1,2,2,2,2,2,2,1,2,2,2,2,2,2,1].each{|n|
    cn << cn.last.left(n)
    dn << dn.last.left(n)
  }
  cdn=[]
  cn.zip(dn) {|c,d| cdn << (c+d)} # объединяет массивы
  cdn
end

def des_encrypt(m, keys) #берет 8 байтовое сообщение и полученные ключи и ширфует по дес алгоритму электронная кодовая книга ЕСВ (Electronic Code Book)
  ip = m.ip #пропускает через IP перестановку
  l, r = ip.split #разделяет на две части 
  (1..16).each {|i| #16 раундов перестановок
    l,r = r,l.xor(f(r,keys[i]))
    }
    rl = r+l #соединяет две части обратно
    c=rl.ip_inverse #пропускает через обратную IP перестановку и выдает нам шифрограмму
end

def f(r,k) #функция берет правую сторону(r) и ключ, затем проделывает следующие операции На вход поступает 32-битовая половина шифруемого блока Li и 48-битовый ключевой элемент ki.
  e = r.e_bits  # высчитывает E(Rn-1), функция расширения Е, там тетрадры бла-бла-бла
  x = e.xor(k)  # Икс побитово суммируется по модулю 2 с ключевым элементом
  bs = x.split6 # делит на 8 6-битовых массивов
  s = []        
  bs.each_with_index{|b,i| s += b.s_box(i+1)} #  Каждое из значений hj преобразуется в новое 4-битовое значение tj с помощью соответствующего узла замены Sj.
  s.perm_p      # В H’ выполняется перестановка битов P
end
def des_decrypt(m,keys) #берем 8 битовой сообщение и извлеченные ключи ну и
  ip = m.ip          # пропускаем через IP перестановку
  l, r = ip.split    # делим на две части
  (1..16).to_a.reverse.each { |i| # пропускаем через этапы шифрования
    l, r = r, l.xor(f(r,keys[i])) # L => R,  R => L + f(Rn-1,Kn)
  }
  rl = r + l        # 
  c = rl.ip_inverse # 
end

def tripledes_encrypt_ede2(m, key)
  key_a, key_b = key.split   # Split the 128-bit TripleDES key into two DES keys
  keys_a = expand(key_a)     # Expand the two DES keys
  keys_b = expand(key_b)
  c = des_encrypt(m, keys_a) # Encrypt by the first key
  c = des_decrypt(c, keys_b) # Decrypt by the second key
  c = des_encrypt(c, keys_a) # Encrypt by the first key again
end
def tripledes_decrypt_ede2(c, key)
  key_a, key_b = key.split   # Split the 128-bit TripleDES key into two DES keys
  keys_a = expand(key_a)     # Expand the two DES keys
  keys_b = expand(key_b)
  c = des_decrypt(c, keys_a) # Encrypt by the first key
  c = des_encrypt(c, keys_b) # Decrypt by the second key
  c = des_decrypt(c, keys_a) # Encrypt by the first key again
end

def tripledes_encrypt_ede3(m, key)
  key_a, key_b, key_c = key.split_3
  keys_a = expand(key_a)
  keys_b = expand(key_b)
  keys_c = expand(key_c)
  c = des_encrypt(m, keys_a) 
  c = des_decrypt(c, keys_b) 
  c = des_encrypt(c, keys_c) 
end
def tripledes_decrypt_ede3(c, key)
  key_a, key_b, key_c = key.split_3
  keys_a = expand(key_a)
  keys_b = expand(key_b)
  keys_c = expand(key_c)
  c = des_decrypt(c, keys_c) 
  c = des_encrypt(c, keys_b) 
  c = des_decrypt(c, keys_a) 
end

def tripledes_encrypt_eee3(m, key)
  key_a, key_b, key_c = key.split_3
  keys_a = expand(key_a)
  keys_b = expand(key_b)
  keys_c = expand(key_c)
  c = des_encrypt(m, keys_a)
  c = des_encrypt(c, keys_b) 
  c = des_encrypt(c, keys_c) 
end
def tripledes_decrypt_eee3(c, key)
  key_a, key_b, key_c = key.split_3
  keys_a = expand(key_a)
  keys_b = expand(key_b)
  keys_c = expand(key_c)
  c = des_decrypt(c, keys_c) 
  c = des_decrypt(c, keys_b) 
  c = des_decrypt(c, keys_a) 
end

def tripledes_encrypt_eee2(m, key)
  key_a, key_b = key.split
  keys_a = expand(key_a)
  keys_b = expand(key_b)
  c = des_encrypt(m, keys_a) 
  c = des_encrypt(c, keys_b) 
  c = des_encrypt(c, keys_a) 
end
def tripledes_decrypt_eee2(c, key)
  key_a, key_b = key.split
  keys_a = expand(key_a)
  keys_b = expand(key_b)
  c = des_decrypt(c, keys_a) 
  c = des_decrypt(c, keys_b) 
  c = des_decrypt(c, keys_a) 
end
def cbc(key)
  output = ""
  old_key = []
  keys_arr = []
  start_key = '00111010 00111010 11001100 01100101 00101101 10110001 10110001 11001100'.to_bits 
  keys = expand(key)
  puts "Please, input the encrypted message for DES CBC-mode"
  input_cbc = gets.chomp
  8.times do
    if input_cbc.length%8!=0
    input_cbc = input_cbc.pad
  end
  end
  input_array = input_cbc.scan(/......../)
  input_array.each_with_index do |x,bit|
    x = x.to_bytes.to_bits
    if bit==0 
      x = x.xor(start_key)
      x = des_encrypt(x, keys)
      keys_arr<<x    
      puts "Des CBC Encrypt pt%2d: "%[bit+1] + x.pretty
    else
      x = x.xor(keys_arr[bit-1])
      x = des_encrypt(x,keys)
      keys_arr<<x
      puts "DES CBC Encrypt pt%2d: "%[bit+1] + x.pretty
    end
  end
  keys_arr.each_with_index do |x,bit|
    if bit==0
      x = des_decrypt(x, keys)
      x = x.xor(start_key)
      output+=x.to_string     
    else
      x = des_decrypt(x, keys)
      x = x.xor(keys_arr[bit-1])
      output+=x.to_string
    end
  end
  puts "DES CBC Decrypt: " +output
end
general_decrypt1=""
general_decrypt2=""
general_decrypt3=""
general_decrypt4=""
general_decrypt5=""
message_array = []
puts "Please, input the key for cbc DES-mode. Key should has the length equal to 8 symbols"
k = gets.chomp.to_bytes.to_bits.add_byte.norm_vid
if k.length !=64  then
  puts "The key should has the length equal to 8 symbols"
  abort
end
cbc(k)

subkeys = expand(k)
print "Key: "+ k.pretty()
puts ""
subkeys.each_with_index{|sk,i| puts "Subkey %2d: %s" % [i+1,sk.pretty(6)]}
puts "Please, input the encrypted message for DES EBC, Triple DES-modes"
test = gets.chomp
8.times do
  if test.length%8!=0
    test = test.pad
  end
end
message_array = test.scan(/......../)

message_array.each do |m|
  m = m.to_bytes.to_bits
  if m.length%64!=0 then
  puts "The encrypted message should has the lentgh equal to 8 symbols"
  abort
end

c = des_encrypt(m,subkeys)
puts "Encrypt EBC: " +c.pretty(8)

d = des_decrypt(c,subkeys)
d = d.to_string
puts "Decrypt EBC: " + d
general_decrypt5+=d
puts "Please, input the first key for triple DES-modes. Key should has the length equal to 8 symbols"
k1 = gets.chomp.to_bytes.to_bits.add_byte.norm_vid
if k.length !=64  then
  puts "The key should has the length equal to 8 symbols"
  abort
end
puts "Please, input the second key for tirple DES-modes. Key should has the length equal to 8 symbols"
k2 = gets.chomp.to_bytes.to_bits.add_byte.norm_vid
if k.length !=64  then
  puts "The key should has the length equal to 8 symbols"
  abort
end
puts "Please, input the third key for triple DES-modes(This third key is only for EEE3 and EDE3). Key should has the length equal to 8 symbols"
k3 = gets.chomp.to_bytes.to_bits.add_byte.norm_vid
if k.length !=64  then
  puts "The key should has the length equal to 8 symbols"
  abort
end
k3d = k1+k2
m3d = m
k3d3 = k1+k2+k3
e = tripledes_encrypt_ede2(m3d,k3d)
d = tripledes_decrypt_ede2(e,k3d)
puts "Triple Des Message: " + m3d.to_string
puts "Triple Des Encrypt DES-EDE2: " + e.pretty(8)
puts "Triple Des Decrypt DES-EDE2: " + d.to_string
general_decrypt1+=d.to_string
e = tripledes_encrypt_ede3(m3d, k3d3)
d = tripledes_decrypt_ede3(e, k3d3)
puts "Triple Des Encrypt DES-EDE3: " + e.pretty(8)
puts "Triple Des Decrypt DES-EDE3: " + d.to_string
general_decrypt2+=d.to_string
e = tripledes_encrypt_eee3(m3d, k3d3)
d = tripledes_decrypt_eee3(e, k3d3)
puts "Triple Des Encrypt DES-EEE3: " + e.pretty(8)
puts "Triple Des Decrypt DES-EEE3: " + d.to_string
general_decrypt3+=d.to_string
e = tripledes_encrypt_eee2(m3d, k3d)
d = tripledes_decrypt_eee2(e, k3d)
puts "Triple Des Encrypt DES-EEE2: " + e.pretty(8)
puts "Triple Des Decrypt DES-EEE2: " + d.to_string
general_decrypt4+=d.to_string
end

puts "Triple Des Decrypt DES-EDE2: " + general_decrypt1
puts "Triple Des Decrypt DES-EDE3: " + general_decrypt2
puts "Triple Des Decrypt DES-EEE3: " + general_decrypt3
puts "Triple Des Decrypt DES-EEE2: " + general_decrypt4
puts "Des Decrypts DES-ECB: " + general_decrypt5



























