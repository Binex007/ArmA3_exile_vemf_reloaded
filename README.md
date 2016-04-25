#ArmA3_exile_vemf_reloaded
###VEMFr; система миссий для ArmA3 Exile Mod
####На основе VEMF (Vampire's Epoch Mission Framework)
<br />
#####РУКОВОДСТВО ПО УСТАНОВКЕ
######На стороне сервера
```
закинуть два файла в ваш сервер 
exile_vemf_reloaded.pbo >> @ExileServer\addons\
exile_vemf_reloaded_config.pbo >> @ExileServer\addons\
```
######На стороне клиента
* Копируем папку VEMFr_client в папку вашей миссии.
* Вам нужно открыть файл миссии вашего сервера.
* Если вы используете карту Altis например, он будет называется Exile.Altis.pbo.
* Или при запуске например Esseker, то это будет Exile.Esseker.pbo.
* Обычно этот файл расположен в папке mpmissions, которая находится в корневом каталоге вашего сервера.
* Просто распакуйте этот файл и перейдите в папку.
* Там должен быть файл с именем description.ext . Откройте его и найдите строку class RscTitles
* Если вы не можете найти ее, можете добавьте в нижней части вашего description.ext
```
class RscTitles
{
	#include "VEMFr_client\gui\RscDisplayVEMFrClient.hpp"
};
```
<br />
в папке вашей миссии создайте файл init.sqf и добавить в него это
```
if hasInterface then
{
	[] ExecVM "VEMFr_client\sqf\initClient.sqf"; 
};
```
######КОНФИГУРАЦИИ
Чтобы настроить VEMFr по вашему вкусу, отредактируйте *config_override.cpp*, расположенный внутри *exile_vemf_reloaded_config.pbo* <br />
