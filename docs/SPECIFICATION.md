# USER STORIES

**1. Jako użytkownik chcę założyć konto, aby moje zadania były bezpiecznie przechowywane.**

- **AC:** Formularz wymaga loginu i hasła. Po udanej rejestracji system automatycznie loguje użytkownika.

**2. Jako użytkownik chcę się zalogować, aby uzyskać dostęp do swoich zadań.**

- **AC:** System autentykuje użytkownika. W przypadku błędu wyświetla komunikat "Nieprawidłowy login lub hasło".

**3. Jako użytkownik chcę się wylogować, aby nikt inny nie miał dostępu do moich danych z danego urządzenia.**

- **AC:** Kliknięcie "Wyloguj" usuwa token JWT z pamięci lokalnej i przekierowuje na ekran logowania.

**4. Jako użytkownik chcę widzieć listę wszystkich zadań z podziałem na aktywne i nieaktywne, aby wiedzieć, co mam do zrobienia.**

- **AC:** Widok listy z zadaniami. W przypadku braku zadań wyświetla odpowiedni komunikat.

**5. Jako użytkownik chcę widzieć na liście oznaczenie, które zadania są stałe, a które jednorazowe, aby łatwiej zarządzać swoimi celami.**

- **AC:** Kafelki zadań na widoku listy posiadają odpowiednią ikonę lub etykietę informującą o ich typie.

**6. Jako użytkownik chcę dodać nowe zadanie, aby zapisać to, o czym muszę pamiętać.**

- **AC:** Formularz zawiera pole tytułu (wymagane) i opisu (opcjonalne). Maksymalna długość tytułu to 50 znaków.

**7. Jako użytkownik chcę podczas tworzenia zadania określić, czy ma ono charakter jednorazowy, czy stały, aby zdefiniować cykl jego życia.**

- **AC:** W formularzu dodawania oraz edycji zadania znajduje się widoczny komponent (np. toggle switch) z opcją „Typ zadania: Jednorazowe / Stałe”.

**8. Jako użytkownik chcę oznaczyć zadanie jako wykonane, aby zniknęło z listy aktywnych.**

- **AC:** Przesunięcie kafelka zadania (swipe) lub kliknięcie checkboxa dezaktywuje powiadomienia dla tego zadania i ukrywa je z głównego widoku.

**9. Jako użytkownik chcę edytować istniejące zadanie, aby poprawić błąd lub zmienić warunki przypomnienia.**

- **AC:** Edycja nadpisuje dane w bazie lokalnej i wysyła PUT/PATCH do API.

**10. Jako użytkownik chcę usunąć zadanie, którego już nie potrzebuję.**

- **AC:** System prosi o potwierdzenie usunięcia. Po potwierdzeniu zadanie znika na zawsze (hard delete).

**11. Jako użytkownik chcę dodać wyzwalacz czasowy do zadania, aby otrzymać powiadomienie o konkretnej godzinie.**

- **AC:** Wybór daty i godziny przez natywny date/time picker Androida. Nie można ustawić daty z przeszłości.

**12. Jako użytkownik chcę dodać wyzwalacz geograficzny, wybierając punkt na mapie.**

- **AC:** Widok mapy z możliwością wyboru lokalizacji. Domyślny promień geofencingu wynosi 100 metrów.

**13. Jako użytkownik chcę otrzymać powiadomienie Push, gdy nadejdzie czas wykonania zadania.**

- **AC:** Powiadomienie pojawia się nawet, gdy aplikacja jest zamknięta. Zawiera tytuł zadania.

**14. Jako użytkownik chcę otrzymać powiadomienie Push, gdy wejdę w (lub wyjdę z) zdefiniowany obszar geograficzny przypisany do zadania.**

- **AC:** Powiadomienie jest wyzwalane przez systemowe usługi lokalizacyjne.

**15. Jako użytkownik muszę nadać uprawnienia do lokalizacji i powiadomień, aby system mógł w ogóle działać.**

- **AC:** Ekran wdrożeniowy (onboarding) tłumaczący, dlaczego uprawnienia są potrzebne. Jeśli użytkownik odmówi uprawnień, blokowane jest tworzenie zadań lokalizacyjnych.

**16. Jako użytkownik chcę móc dodawać zadania będąc offline (bez internetu), aby nie przerywać mojej pracy.**

- **AC:** Aplikacja zapisuje zadanie w lokalnej bazie z flagą "niezsynchronizowane" i ustawia lokalny wyzwalacz powiadomień.

**17. Jako użytkownik chcę widzieć moje zadania na mapie, aby móc wizualnie ocenić, gdzie mam coś do załatwienia.**

- **AC 1:** Widok mapy wyświetla markery w miejscach przypisanych do zadań z wyzwalaczem geograficznym.

- **AC 2:** Kliknięcie w marker pokazuje dymek (tooltip) z tytułem zadania i przyciskiem "Szczegóły", który przenosi do edycji zadania.

- **AC 3:** Mapa automatycznie centruje się na aktualnej pozycji użytkownika po jej otwarciu (jeśli wyrażono zgodę na lokalizację).

- **AC 4:** Zadania wykonane (nieaktywne) są ukryte na mapie.

<br>

# UZASADNIENIE SMARTFONA

Aplikacja opiera się na koncepcji przypomnień kontekstowych, co z definicji wyklucza użyteczność aplikacji desktopowej.

- **Mobilność użytkownika:** Urządzenie musi przemieszczać się fizycznie razem z użytkownikiem, aby mechanizm geofencingu miał sens. Desktop stoi w miejscu.

- **Usługi lokalizacyjne w tle:** Smartfony posiadają wbudowane układy GPS oraz zoptymalizowane pod kątem zużycia baterii mechanizmy nasłuchiwania zmian lokalizacji w tle (np. Fused Location Provider w Androidzie).

- **Powiadomienia Push natywne dla OS:** Skuteczne przypomnienie musi natychmiastowo zwrócić uwagę użytkownika (dźwięk, wibracja, ekran blokady), co gwarantują powiadomienia systemowe smartfona.

<br>

# MVP vs Funkcje dodatkowe

### MVP (Minimum Viable Product):

- Rejestracja i logowanie (login + hasło).

- CRUD zadań (tworzenie, odczyt, aktualizacja, usuwanie).

- Dodawanie przypomnień opartych o konkretną datę i godzinę.

- Dodawanie przypomnień opartych o lokalizację (wybór punktu na mapie).

- Otrzymywanie powiadomień Push (czasowych i lokalizacyjnych).

- Tryb offline-first z lokalnym buforowaniem danych i synchronizacją po odzyskaniu połączenia.

### Funkcje dodatkowe (Out of scope / do odrzucenia):

- Powtarzalne zadania (codziennie/co tydzień).

- Złożone reguły geofencingu (np. powiadomienie przy wyjściu ze strefy).

- Tryb ciemny.

<br>

# Opis do Google Play

**Krótki opis:** Otrzymuj przypomnienia o zadaniach na podstawie czasu lub miejsca, w którym jesteś.

**Pełny opis:** System przypomnień kontekstowych to inteligentny asystent, który wie, co i kiedy musisz zrobić, ale co ważniejsze – gdzie. Koniec z przypomnieniami o zrobieniu zakupów, gdy siedzisz w biurze. Dzięki wykorzystaniu geofencingu, aplikacja powiadomi Cię o zadaniu dopiero wtedy, gdy fizycznie zbliżysz się do wyznaczonego miejsca. Przechodzisz obok apteki? Otrzymasz powiadomienie o wykupieniu recepty.

Główne funkcje:

- Przypomnienia czasowe z precyzyjnymi alertami Push.

- Przypomnienia przestrzenne (Geofencing) – oznacz punkt na mapie i ustal promień wyzwolenia zadania.

- Praca w trybie offline – możesz dodawać zadania bez dostępu do sieci, aplikacja zsynchronizuje je z serwerem, gdy tylko wrócisz do zasięgu.

- Bezpieczeństwo i prywatność danych poprzez integrację z chmurowym backendem.

Aby aplikacja działała poprawnie, wymaga dostępu do Twojej lokalizacji w tle oraz zgody na wysyłanie powiadomień.

**Słowa kluczowe:** przypomnienia, geofencing, lista zadań, to-do, lokalizacja, produktywność, planowanie, organizacja czasu, przypomnienie alarm, offline todo.
