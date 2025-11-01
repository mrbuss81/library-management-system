--
-- PostgreSQL database dump
--

\restrict RbFoQBDzYju9lLyR7dNCSh12Ce1JkhqH5damVQ90xq2OLo8iUmqpFLuLcaCFJhD

-- Dumped from database version 14.19 (Homebrew)
-- Dumped by pg_dump version 14.19 (Homebrew)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: author; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.author (
    author_id integer NOT NULL,
    name character varying(100) NOT NULL,
    email character varying(100),
    CONSTRAINT author_email_check CHECK (((email IS NULL) OR ((email)::text ~~ '%@%.%'::text)))
);


ALTER TABLE public.author OWNER TO postgres;

--
-- Name: TABLE author; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.author IS 'Stores author information, including name and optional email.';


--
-- Name: COLUMN author.name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.author.name IS 'Full name of the author.';


--
-- Name: COLUMN author.email; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.author.email IS 'Email address of the author (unique if provided).';


--
-- Name: author_author_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.author_author_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.author_author_id_seq OWNER TO postgres;

--
-- Name: author_author_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.author_author_id_seq OWNED BY public.author.author_id;


--
-- Name: book; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.book (
    book_id integer NOT NULL,
    title character varying(150) NOT NULL,
    isbn character(13) NOT NULL,
    publication_year integer,
    availability_status character varying(20) DEFAULT 'Available'::character varying,
    publisher_id integer,
    CONSTRAINT book_availability_status_check CHECK (((availability_status)::text = ANY ((ARRAY['Available'::character varying, 'Checked Out'::character varying, 'Reserved'::character varying])::text[]))),
    CONSTRAINT book_publication_year_check CHECK (((publication_year >= 1400) AND ((publication_year)::numeric <= EXTRACT(year FROM CURRENT_DATE))))
);


ALTER TABLE public.book OWNER TO postgres;

--
-- Name: TABLE book; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.book IS 'Stores library catalog information, including publisher and availability.';


--
-- Name: COLUMN book.isbn; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.book.isbn IS 'Unique 13-digit ISBN for the book.';


--
-- Name: COLUMN book.availability_status; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.book.availability_status IS 'Tracks whether a book is available, checked out or reserved.';


--
-- Name: book_book_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.book_book_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.book_book_id_seq OWNER TO postgres;

--
-- Name: book_book_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.book_book_id_seq OWNED BY public.book.book_id;


--
-- Name: fine; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fine (
    fine_id integer NOT NULL,
    member_id integer NOT NULL,
    loan_id integer,
    amount numeric(6,2) NOT NULL,
    fine_date date DEFAULT CURRENT_DATE,
    paid_status boolean DEFAULT false,
    CONSTRAINT fine_amount_check CHECK ((amount > (0)::numeric))
);


ALTER TABLE public.fine OWNER TO postgres;

--
-- Name: TABLE fine; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.fine IS 'Records fines for overdue or damaged books.';


--
-- Name: COLUMN fine.amount; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.fine.amount IS 'Fine amount in dollars (must be positive).';


--
-- Name: COLUMN fine.paid_status; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.fine.paid_status IS 'True if fine is paid, FALSE if still owed.';


--
-- Name: fine_fine_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.fine_fine_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.fine_fine_id_seq OWNER TO postgres;

--
-- Name: fine_fine_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.fine_fine_id_seq OWNED BY public.fine.fine_id;


--
-- Name: loan; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.loan (
    loan_id integer NOT NULL,
    member_id integer NOT NULL,
    book_id integer NOT NULL,
    staff_id integer NOT NULL,
    loan_date date DEFAULT CURRENT_DATE,
    due_date date NOT NULL,
    return_date date,
    CONSTRAINT loan_check CHECK ((due_date >= loan_date))
);


ALTER TABLE public.loan OWNER TO postgres;

--
-- Name: TABLE loan; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.loan IS 'Tracks loans of books from members, processed by staff.';


--
-- Name: COLUMN loan.due_date; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loan.due_date IS 'The date when the book is due for return.';


--
-- Name: COLUMN loan.return_date; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loan.return_date IS 'The date when the book was actually returned.';


--
-- Name: loan_loan_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.loan_loan_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.loan_loan_id_seq OWNER TO postgres;

--
-- Name: loan_loan_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.loan_loan_id_seq OWNED BY public.loan.loan_id;


--
-- Name: member; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.member (
    member_id integer NOT NULL,
    name character varying(100) NOT NULL,
    email character varying(100) NOT NULL,
    join_date date DEFAULT CURRENT_DATE,
    member_type character varying(20) DEFAULT 'Standard'::character varying,
    CONSTRAINT member_member_type_check CHECK (((member_type)::text = ANY ((ARRAY['Standard'::character varying, 'Faculty'::character varying, 'Student'::character varying])::text[])))
);


ALTER TABLE public.member OWNER TO postgres;

--
-- Name: TABLE member; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.member IS 'Stores information about registered library members.';


--
-- Name: COLUMN member.join_date; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.member.join_date IS 'Date when the member joined the library.';


--
-- Name: COLUMN member.member_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.member.member_type IS 'Defines member category: Standard, Faculty, or Student.';


--
-- Name: member_member_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.member_member_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.member_member_id_seq OWNER TO postgres;

--
-- Name: member_member_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.member_member_id_seq OWNED BY public.member.member_id;


--
-- Name: publisher; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.publisher (
    publisher_id integer NOT NULL,
    name character varying(100) NOT NULL,
    email character varying(100) NOT NULL,
    CONSTRAINT publisher_email_check CHECK (((email)::text ~~ '%@%.%'::text))
);


ALTER TABLE public.publisher OWNER TO postgres;

--
-- Name: TABLE publisher; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.publisher IS 'Stores publisher details for the library system.';


--
-- Name: COLUMN publisher.name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.publisher.name IS 'Name of the publishing company.';


--
-- Name: COLUMN publisher.email; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.publisher.email IS 'Contact email address for the publisher.';


--
-- Name: publisher_publisher_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.publisher_publisher_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.publisher_publisher_id_seq OWNER TO postgres;

--
-- Name: publisher_publisher_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.publisher_publisher_id_seq OWNED BY public.publisher.publisher_id;


--
-- Name: reservation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reservation (
    reservation_id integer NOT NULL,
    member_id integer NOT NULL,
    book_id integer NOT NULL,
    reservation_date date DEFAULT CURRENT_DATE,
    status character varying(20) DEFAULT 'Pending'::character varying,
    CONSTRAINT reservation_status_check CHECK (((status)::text = ANY ((ARRAY['Pending'::character varying, 'Fulfilled'::character varying, 'Cancelled'::character varying])::text[])))
);


ALTER TABLE public.reservation OWNER TO postgres;

--
-- Name: TABLE reservation; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.reservation IS 'Tracks member reservations for specific books.';


--
-- Name: COLUMN reservation.reservation_date; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.reservation.reservation_date IS 'Date the reservation was made.';


--
-- Name: COLUMN reservation.status; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.reservation.status IS 'Reservation status: Pending, Fulfilled, or Cancelled.';


--
-- Name: reservation_reservation_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.reservation_reservation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.reservation_reservation_id_seq OWNER TO postgres;

--
-- Name: reservation_reservation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.reservation_reservation_id_seq OWNED BY public.reservation.reservation_id;


--
-- Name: staff; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.staff (
    staff_id integer NOT NULL,
    name character varying(100) NOT NULL,
    email character varying(100) NOT NULL,
    role character varying(100) DEFAULT 'Librarian'::character varying NOT NULL,
    start_date date DEFAULT CURRENT_DATE,
    CONSTRAINT staff_role_check CHECK (((role)::text = ANY ((ARRAY['Librarian'::character varying, 'Assistant'::character varying, 'Manager'::character varying])::text[])))
);


ALTER TABLE public.staff OWNER TO postgres;

--
-- Name: TABLE staff; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.staff IS 'Stores library staff details, including role and start date.';


--
-- Name: COLUMN staff.role; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.staff.role IS 'Job title or position (default Librarian).';


--
-- Name: COLUMN staff.start_date; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.staff.start_date IS 'Date when the staff member started employment.';


--
-- Name: staff_staff_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.staff_staff_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.staff_staff_id_seq OWNER TO postgres;

--
-- Name: staff_staff_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.staff_staff_id_seq OWNED BY public.staff.staff_id;


--
-- Name: writes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.writes (
    author_id integer NOT NULL,
    book_id integer NOT NULL
);


ALTER TABLE public.writes OWNER TO postgres;

--
-- Name: TABLE writes; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.writes IS 'Associates authors with books they have written.';


--
-- Name: COLUMN writes.author_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.writes.author_id IS 'Foreign key linking to Author table.';


--
-- Name: COLUMN writes.book_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.writes.book_id IS 'Foreign key linking to Book table.';


--
-- Name: author author_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.author ALTER COLUMN author_id SET DEFAULT nextval('public.author_author_id_seq'::regclass);


--
-- Name: book book_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.book ALTER COLUMN book_id SET DEFAULT nextval('public.book_book_id_seq'::regclass);


--
-- Name: fine fine_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fine ALTER COLUMN fine_id SET DEFAULT nextval('public.fine_fine_id_seq'::regclass);


--
-- Name: loan loan_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loan ALTER COLUMN loan_id SET DEFAULT nextval('public.loan_loan_id_seq'::regclass);


--
-- Name: member member_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.member ALTER COLUMN member_id SET DEFAULT nextval('public.member_member_id_seq'::regclass);


--
-- Name: publisher publisher_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.publisher ALTER COLUMN publisher_id SET DEFAULT nextval('public.publisher_publisher_id_seq'::regclass);


--
-- Name: reservation reservation_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reservation ALTER COLUMN reservation_id SET DEFAULT nextval('public.reservation_reservation_id_seq'::regclass);


--
-- Name: staff staff_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff ALTER COLUMN staff_id SET DEFAULT nextval('public.staff_staff_id_seq'::regclass);


--
-- Data for Name: author; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.author (author_id, name, email) FROM stdin;
1	Author A	authorA@example.com
2	Author B	authorB@example.com
3	Author C	authorC@example.com
4	Author D	authorD@example.com
5	Author E	authorE@example.com
\.


--
-- Data for Name: book; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.book (book_id, title, isbn, publication_year, availability_status, publisher_id) FROM stdin;
1	Book A	9780000000001	2001	Available	1
2	Book B	9780000000002	2005	Available	2
3	Book C	9780000000003	2010	Available	3
4	Book D	9780000000004	2015	Available	4
5	Book E	9780000000005	2020	Available	5
\.


--
-- Data for Name: fine; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fine (fine_id, member_id, loan_id, amount, fine_date, paid_status) FROM stdin;
1	1	1	3.50	2025-09-16	t
2	2	2	1.75	2025-09-20	f
3	3	3	5.00	2025-09-25	f
4	4	4	2.25	2025-09-28	t
5	5	5	4.00	2025-09-30	f
6	1	6	2.00	2025-10-25	f
\.


--
-- Data for Name: loan; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.loan (loan_id, member_id, book_id, staff_id, loan_date, due_date, return_date) FROM stdin;
1	1	1	1	2025-09-01	2025-09-15	2025-09-12
2	2	2	2	2025-09-05	2025-09-19	2025-09-18
3	3	3	3	2025-09-10	2025-09-24	\N
4	4	4	4	2025-09-12	2025-09-26	\N
5	5	5	5	2025-09-15	2025-09-29	2025-09-25
6	1	2	1	2025-10-05	2025-10-20	\N
\.


--
-- Data for Name: member; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.member (member_id, name, email, join_date, member_type) FROM stdin;
1	Member A	memberA@example.com	2024-01-01	Standard
2	Member B	memberB@example.com	2024-02-15	Student
3	Member C	memberC@example.com	2024-03-10	Faculty
4	Member D	memberD@example.com	2024-04-20	Standard
5	Member E	memberE@example.com	2024-05-05	Student
6	Member F	memberF@example.com	2025-01-01	Standard
\.


--
-- Data for Name: publisher; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.publisher (publisher_id, name, email) FROM stdin;
1	Publisher A	pubA@example.com
2	Publisher B	pubB@example.com
3	Publisher C	pubC@example.com
4	Publisher D	pubD@example.com
5	Publisher E	pubE@example.com
\.


--
-- Data for Name: reservation; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.reservation (reservation_id, member_id, book_id, reservation_date, status) FROM stdin;
1	1	3	2025-10-01	Pending
2	2	4	2025-10-02	Fulfilled
3	3	1	2025-10-03	Cancelled
4	4	2	2025-10-04	Pending
5	5	5	2025-10-05	Pending
6	6	3	2025-10-10	Pending
\.


--
-- Data for Name: staff; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.staff (staff_id, name, email, role, start_date) FROM stdin;
1	Staff A	staffA@library.ca	Librarian	2023-01-10
2	Staff B	staffB@library.ca	Assistant	2023-05-12
3	Staff C	staffC@library.ca	Manager	2024-02-01
4	Staff D	staffD@library.ca	Librarian	2024-04-20
5	Staff E	staffE@library.ca	Assistant	2024-06-15
\.


--
-- Data for Name: writes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.writes (author_id, book_id) FROM stdin;
1	1
2	2
3	3
4	4
5	5
\.


--
-- Name: author_author_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.author_author_id_seq', 5, true);


--
-- Name: book_book_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.book_book_id_seq', 5, true);


--
-- Name: fine_fine_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.fine_fine_id_seq', 6, true);


--
-- Name: loan_loan_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.loan_loan_id_seq', 6, true);


--
-- Name: member_member_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.member_member_id_seq', 6, true);


--
-- Name: publisher_publisher_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.publisher_publisher_id_seq', 5, true);


--
-- Name: reservation_reservation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.reservation_reservation_id_seq', 6, true);


--
-- Name: staff_staff_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.staff_staff_id_seq', 5, true);


--
-- Name: author author_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.author
    ADD CONSTRAINT author_email_key UNIQUE (email);


--
-- Name: author author_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.author
    ADD CONSTRAINT author_pkey PRIMARY KEY (author_id);


--
-- Name: book book_isbn_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.book
    ADD CONSTRAINT book_isbn_key UNIQUE (isbn);


--
-- Name: book book_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.book
    ADD CONSTRAINT book_pkey PRIMARY KEY (book_id);


--
-- Name: fine fine_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fine
    ADD CONSTRAINT fine_pkey PRIMARY KEY (fine_id);


--
-- Name: loan loan_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loan
    ADD CONSTRAINT loan_pkey PRIMARY KEY (loan_id);


--
-- Name: member member_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.member
    ADD CONSTRAINT member_email_key UNIQUE (email);


--
-- Name: member member_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.member
    ADD CONSTRAINT member_pkey PRIMARY KEY (member_id);


--
-- Name: publisher publisher_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.publisher
    ADD CONSTRAINT publisher_pkey PRIMARY KEY (publisher_id);


--
-- Name: reservation reservation_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reservation
    ADD CONSTRAINT reservation_pkey PRIMARY KEY (reservation_id);


--
-- Name: staff staff_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff
    ADD CONSTRAINT staff_email_key UNIQUE (email);


--
-- Name: staff staff_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff
    ADD CONSTRAINT staff_pkey PRIMARY KEY (staff_id);


--
-- Name: writes writes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.writes
    ADD CONSTRAINT writes_pkey PRIMARY KEY (author_id, book_id);


--
-- Name: idx_book_publisher_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_book_publisher_id ON public.book USING btree (publisher_id);


--
-- Name: idx_fine_loan_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_fine_loan_id ON public.fine USING btree (loan_id);


--
-- Name: idx_fine_member_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_fine_member_id ON public.fine USING btree (member_id);


--
-- Name: idx_loan_book_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_loan_book_id ON public.loan USING btree (book_id);


--
-- Name: idx_loan_member_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_loan_member_id ON public.loan USING btree (member_id);


--
-- Name: idx_loan_staff_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_loan_staff_id ON public.loan USING btree (staff_id);


--
-- Name: idx_reservation_book_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_reservation_book_id ON public.reservation USING btree (book_id);


--
-- Name: idx_reservation_member_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_reservation_member_id ON public.reservation USING btree (member_id);


--
-- Name: idx_writes_author_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_writes_author_id ON public.writes USING btree (author_id);


--
-- Name: idx_writes_book_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_writes_book_id ON public.writes USING btree (book_id);


--
-- Name: book book_publisher_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.book
    ADD CONSTRAINT book_publisher_id_fkey FOREIGN KEY (publisher_id) REFERENCES public.publisher(publisher_id) ON DELETE SET NULL;


--
-- Name: fine fine_loan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fine
    ADD CONSTRAINT fine_loan_id_fkey FOREIGN KEY (loan_id) REFERENCES public.loan(loan_id) ON DELETE SET NULL;


--
-- Name: fine fine_member_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fine
    ADD CONSTRAINT fine_member_id_fkey FOREIGN KEY (member_id) REFERENCES public.member(member_id) ON DELETE CASCADE;


--
-- Name: loan loan_book_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loan
    ADD CONSTRAINT loan_book_id_fkey FOREIGN KEY (book_id) REFERENCES public.book(book_id) ON DELETE RESTRICT;


--
-- Name: loan loan_member_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loan
    ADD CONSTRAINT loan_member_id_fkey FOREIGN KEY (member_id) REFERENCES public.member(member_id) ON DELETE CASCADE;


--
-- Name: loan loan_staff_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loan
    ADD CONSTRAINT loan_staff_id_fkey FOREIGN KEY (staff_id) REFERENCES public.staff(staff_id) ON DELETE SET NULL;


--
-- Name: reservation reservation_book_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reservation
    ADD CONSTRAINT reservation_book_id_fkey FOREIGN KEY (book_id) REFERENCES public.book(book_id) ON DELETE CASCADE;


--
-- Name: reservation reservation_member_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reservation
    ADD CONSTRAINT reservation_member_id_fkey FOREIGN KEY (member_id) REFERENCES public.member(member_id) ON DELETE CASCADE;


--
-- Name: writes writes_author_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.writes
    ADD CONSTRAINT writes_author_id_fkey FOREIGN KEY (author_id) REFERENCES public.author(author_id) ON DELETE CASCADE;


--
-- Name: writes writes_book_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.writes
    ADD CONSTRAINT writes_book_id_fkey FOREIGN KEY (book_id) REFERENCES public.book(book_id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict RbFoQBDzYju9lLyR7dNCSh12Ce1JkhqH5damVQ90xq2OLo8iUmqpFLuLcaCFJhD

