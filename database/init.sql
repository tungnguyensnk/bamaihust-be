--
-- PostgreSQL database cluster dump
--

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Drop databases (except postgres and template1)
--

-- DROP DATABASE itss;




--
-- Drop roles
--

-- DROP ROLE postgres;


--
-- Roles
--

-- CREATE ROLE postgres;
ALTER ROLE postgres WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:kCPvoa7q/N+eHNtdqrTjSg==$y67UBWDIzaM7ClySjaVHP72QoyKDWqH9QCvavWuJBdE=:DTR4VSrBPw4kXruOq7xHWkqDnErM7ONBXwD6cegLpwM=';

--
-- User Configurations
--








--
-- Databases
--

--
-- Database "template1" dump
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 15.5
-- Dumped by pg_dump version 15.5

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

UPDATE pg_catalog.pg_database SET datistemplate = false WHERE datname = 'template1';
DROP DATABASE template1;
--
-- Name: template1; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE template1 WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.utf8';


ALTER DATABASE template1 OWNER TO postgres;

\connect template1

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

--
-- Name: DATABASE template1; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON DATABASE template1 IS 'default template for new databases';


--
-- Name: template1; Type: DATABASE PROPERTIES; Schema: -; Owner: postgres
--

ALTER DATABASE template1 IS_TEMPLATE = true;


\connect template1

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

--
-- Name: DATABASE template1; Type: ACL; Schema: -; Owner: postgres
--

REVOKE CONNECT,TEMPORARY ON DATABASE template1 FROM PUBLIC;
GRANT CONNECT ON DATABASE template1 TO PUBLIC;


--
-- PostgreSQL database dump complete
--

--
-- Database "itss" dump
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 15.5
-- Dumped by pg_dump version 15.5

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

--
-- Name: itss; Type: DATABASE; Schema: -; Owner: postgres
--

-- CREATE DATABASE itss WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.utf8';


ALTER DATABASE itss OWNER TO postgres;

\connect itss

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

--
-- Name: itss; Type: DATABASE PROPERTIES; Schema: -; Owner: postgres
--

ALTER DATABASE itss SET "TimeZone" TO 'Asia/Ho_Chi_Minh';


\connect itss

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

--
-- Name: trigger_set_timestamp(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.trigger_set_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

BEGIN

    NEW.updatedat = NOW();

    RETURN NEW;

END;

$$;


ALTER FUNCTION public.trigger_set_timestamp() OWNER TO postgres;

--
-- Name: update_answer_like_count(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_answer_like_count() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

BEGIN

    UPDATE answers

    SET likeCount = (

        SELECT COUNT(*) FROM answer_likes WHERE answer_likes.answerId = NEW.answerId

    )

    WHERE answers.id = NEW.answerId;

    RETURN NEW;

END;

$$;


ALTER FUNCTION public.update_answer_like_count() OWNER TO postgres;

--
-- Name: update_question_like_count(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_question_like_count() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

BEGIN

    UPDATE questions

    SET likeCount = (

        SELECT COUNT(*) FROM question_likes WHERE question_likes.questionId = NEW.questionId

    )

    WHERE questions.id = NEW.questionId;

    RETURN NEW;

END;

$$;


ALTER FUNCTION public.update_question_like_count() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: answer_likes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.answer_likes (
    id integer NOT NULL,
    answerid integer NOT NULL,
    userid integer NOT NULL
);


ALTER TABLE public.answer_likes OWNER TO postgres;

--
-- Name: answer_likes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.answer_likes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.answer_likes_id_seq OWNER TO postgres;

--
-- Name: answer_likes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.answer_likes_id_seq OWNED BY public.answer_likes.id;


--
-- Name: answer_notifications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.answer_notifications (
    id integer NOT NULL,
    senderid integer NOT NULL,
    recipientid integer NOT NULL,
    answerid integer NOT NULL,
    url character varying(255),
    content character varying(255),
    hasread integer DEFAULT 0,
    createdat timestamp without time zone DEFAULT now()
);


ALTER TABLE public.answer_notifications OWNER TO postgres;

--
-- Name: answer_notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.answer_notifications_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.answer_notifications_id_seq OWNER TO postgres;

--
-- Name: answer_notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.answer_notifications_id_seq OWNED BY public.answer_notifications.id;


--
-- Name: answers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.answers (
    id integer NOT NULL,
    content text NOT NULL,
    isanonymous integer DEFAULT 0,
    likecount integer DEFAULT 0,
    userid integer NOT NULL,
    questionid integer NOT NULL,
    createdat timestamp without time zone DEFAULT now(),
    updatedat timestamp without time zone DEFAULT now()
);


ALTER TABLE public.answers OWNER TO postgres;

--
-- Name: answers_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.answers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.answers_id_seq OWNER TO postgres;

--
-- Name: answers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.answers_id_seq OWNED BY public.answers.id;


--
-- Name: question_likes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.question_likes (
    id integer NOT NULL,
    questionid integer NOT NULL,
    userid integer NOT NULL
);


ALTER TABLE public.question_likes OWNER TO postgres;

--
-- Name: question_likes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.question_likes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.question_likes_id_seq OWNER TO postgres;

--
-- Name: question_likes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.question_likes_id_seq OWNED BY public.question_likes.id;


--
-- Name: question_notifications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.question_notifications (
    id integer NOT NULL,
    senderid integer NOT NULL,
    recipientid integer NOT NULL,
    questionid integer NOT NULL,
    url character varying(255),
    content character varying(255),
    hasread integer DEFAULT 0,
    createdat timestamp without time zone DEFAULT now()
);


ALTER TABLE public.question_notifications OWNER TO postgres;

--
-- Name: question_notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.question_notifications_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.question_notifications_id_seq OWNER TO postgres;

--
-- Name: question_notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.question_notifications_id_seq OWNED BY public.question_notifications.id;


--
-- Name: question_tag; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.question_tag (
    id integer NOT NULL,
    tagid integer NOT NULL,
    questionid integer NOT NULL
);


ALTER TABLE public.question_tag OWNER TO postgres;

--
-- Name: question_tag_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.question_tag_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.question_tag_id_seq OWNER TO postgres;

--
-- Name: question_tag_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.question_tag_id_seq OWNED BY public.question_tag.id;


--
-- Name: questions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.questions (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    content text,
    isanonymous integer DEFAULT 0,
    viewcount integer DEFAULT 0,
    likecount integer DEFAULT 0,
    userid integer NOT NULL,
    acceptedanswerid integer,
    createdat timestamp without time zone DEFAULT now(),
    updatedat timestamp without time zone DEFAULT now()
);


ALTER TABLE public.questions OWNER TO postgres;

--
-- Name: questions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.questions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.questions_id_seq OWNER TO postgres;

--
-- Name: questions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.questions_id_seq OWNED BY public.questions.id;


--
-- Name: tags; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tags (
    id integer NOT NULL,
    tagname character varying(255) NOT NULL,
    count integer DEFAULT 0,
    color character varying(255) NOT NULL
);


ALTER TABLE public.tags OWNER TO postgres;

--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tags_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tags_id_seq OWNER TO postgres;

--
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tags_id_seq OWNED BY public.tags.id;


--
-- Name: user_tokens; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_tokens (
    id integer NOT NULL,
    user_id integer NOT NULL,
    token character varying(255) NOT NULL,
    expiration_date timestamp without time zone NOT NULL,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.user_tokens OWNER TO postgres;

--
-- Name: user_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_tokens_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_tokens_id_seq OWNER TO postgres;

--
-- Name: user_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_tokens_id_seq OWNED BY public.user_tokens.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    fullname character varying(255) NOT NULL,
    password character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    reputation integer DEFAULT 0,
    gender integer,
    dateofbirth timestamp without time zone,
    avatarurl character varying(255),
    studentid character varying(255),
    class character varying(255),
    school character varying(255),
    schoolyear character varying(255),
    aboutme text,
    ispublic integer DEFAULT 1,
    createdat timestamp without time zone DEFAULT now(),
    updatedat timestamp without time zone DEFAULT now()
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: answer_likes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.answer_likes ALTER COLUMN id SET DEFAULT nextval('public.answer_likes_id_seq'::regclass);


--
-- Name: answer_notifications id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.answer_notifications ALTER COLUMN id SET DEFAULT nextval('public.answer_notifications_id_seq'::regclass);


--
-- Name: answers id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.answers ALTER COLUMN id SET DEFAULT nextval('public.answers_id_seq'::regclass);


--
-- Name: question_likes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.question_likes ALTER COLUMN id SET DEFAULT nextval('public.question_likes_id_seq'::regclass);


--
-- Name: question_notifications id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.question_notifications ALTER COLUMN id SET DEFAULT nextval('public.question_notifications_id_seq'::regclass);


--
-- Name: question_tag id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.question_tag ALTER COLUMN id SET DEFAULT nextval('public.question_tag_id_seq'::regclass);


--
-- Name: questions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.questions ALTER COLUMN id SET DEFAULT nextval('public.questions_id_seq'::regclass);


--
-- Name: tags id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tags ALTER COLUMN id SET DEFAULT nextval('public.tags_id_seq'::regclass);


--
-- Name: user_tokens id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_tokens ALTER COLUMN id SET DEFAULT nextval('public.user_tokens_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: answer_likes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.answer_likes (id, answerid, userid) FROM stdin;
\.


--
-- Data for Name: answer_notifications; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.answer_notifications (id, senderid, recipientid, answerid, url, content, hasread, createdat) FROM stdin;
\.


--
-- Data for Name: answers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.answers (id, content, isanonymous, likecount, userid, questionid, createdat, updatedat) FROM stdin;
1	Là gì lầu đánh đang quê. Gió đỏ tui một nước thì không. Đá quần tím khoảng mười gió ghế chín kim không.	0	0	2	68	2023-10-29 03:33:04	2023-12-09 01:07:50.090353
2	Ghế gì chìm máy làm leo thích mướn. Thuê nhà đang sáu mướn tím quần mua. Bè đỏ may năm khoảng nhà.	0	0	44	15	2023-02-09 17:43:34	2023-12-09 01:07:50.092541
3	Vẽ chìm mua. Giết hương mười phá em ngọt. Thuyền biết đập ác.	0	0	1	9	2023-01-23 10:24:26	2023-12-09 01:07:50.094591
4	Đá nón máy mười xe hóa bàn bạn tui thế. Tủ đâu được xe vẽ máy viết. Thuyền tôi mười phá trời trăng được khoan thì ngọt.	0	0	70	92	2023-05-07 02:44:33	2023-12-09 01:07:50.09664
5	Viết được tím không nhà mây đã bè tô. Ừ bơi khâu nghỉ nghỉ. Kim trời mười.	0	0	87	10	2023-01-20 18:04:12	2023-12-09 01:07:50.098491
6	Khâu thích gió khoảng yêu anh áo xuồng bơi ừ. Đang đang bạn thế. Là thuyền hết ruộng anh quê bảy đâu.	1	0	76	100	2023-08-11 13:49:04	2023-12-09 01:07:50.100223
7	Á vẽ hai nhà ờ nghỉ bơi á biết đâu. Cửa là cái tủ mây vá áo. Kim độc nha phá đập.	1	0	25	88	2023-04-01 11:53:40	2023-12-09 01:07:50.10214
8	Ừ thuê mười độc ruộng thì xuồng mượn. Con vẽ trăng. Thuyền xuồng yêu ngọt xe xe núi ghế thương trăng.	0	0	7	18	2023-07-20 06:27:40	2023-12-09 01:07:50.103926
9	Yêu ruộng hóa vàng hóa phá chết. Dép gió ghét ba làm. Lầu đâu máy tàu nón ruộng bơi thương.	0	0	7	63	2022-12-18 05:21:34	2023-12-09 01:07:50.10572
10	Được phá yêu. Bơi quần bè là hóa mướn. Khoảng việc đập bè mây trời mua áo ba ghét.	0	0	43	92	2023-01-23 19:21:48	2023-12-09 01:07:50.107417
11	Thế trời hóa ác hóa giết khoan sáu. Chết bốn nước trăng anh cửa. Hóa vàng á vẽ cái khâu.	1	0	52	58	2023-01-04 22:31:08	2023-12-09 01:07:50.109208
12	Ba ghét thì tủ tím độc ngọt thế độc ờ. Gì thế vàng một khoảng làm khâu tủ. Ngọt em thuê chỉ bè vàng hai.	0	0	76	90	2023-10-03 07:42:27	2023-12-09 01:07:50.110751
13	Tủ tàu xe kim hương. Đã đồng ờ tám nghỉ em con bảy mượn. Yêu nước áo bè nghỉ nghỉ lầu.	1	0	70	99	2023-10-12 20:49:03	2023-12-09 01:07:50.112374
14	Quê thế phá chỉ. Thì đập tui tôi. Á tủ bạn nha mượn lầu trời tôi nhà giết.	0	0	6	22	2023-11-11 12:27:21	2023-12-09 01:07:50.114039
15	Năm vá phá hóa lầu vẽ anh bàn. Nghỉ nghỉ mây trăng giết độc nước thương đập. Dép khoảng gì nước hết bàn thì hai nghỉ.	1	0	50	25	2023-07-18 06:55:34	2023-12-09 01:07:50.115669
16	Mượn cái quê xe chết. Đỏ đâu trăng con. Ờ chết xe.	1	0	31	64	2023-05-19 01:18:25	2023-12-09 01:07:50.117261
17	Mượn ghế phá đánh đập đạp thuê hàng xanh gì. Biết mây ngọt gió biển viết tô được. Tủ bàn gió đã.	1	0	13	34	2023-07-20 04:56:55	2023-12-09 01:07:50.118946
18	Mười mượn đánh hết tô đạp bạn ghét bơi vàng. Một bốn làm gió sáu bảy ờ chỉ. Quần lầu không xanh giày may tím ba tím.	0	0	26	51	2023-03-17 18:50:30	2023-12-09 01:07:50.120672
19	Khoảng leo giày được giày mây. Dép độc nghỉ việc khâu trăng. Bàn may đã vàng nhà bè chết.	0	0	86	48	2023-03-06 08:47:08	2023-12-09 01:07:50.122488
20	Là xanh một. Một đập khoảng đánh đập làm máy. Nghỉ lầu bạn việc năm tám chết.	0	0	55	66	2023-10-27 18:22:25	2023-12-09 01:07:50.124495
21	Phá chìm quần bạn nhà bạn đập làm. Viết ừ hàng thuyền dép quần tô đang năm. Hóa con thuê thuê leo.	1	0	65	74	2023-05-20 02:33:54	2023-12-09 01:07:50.126094
22	Ba đang áo. Nha thôi mây tô ghế tôi nghỉ khoan tàu đỏ. Kim nhà được bàn đâu xe quần nghỉ.	0	0	48	17	2022-12-11 13:30:17	2023-12-09 01:07:50.127902
23	Bạn nha khâu một đồng á đập cái không cái. Ờ bảy lầu đồng trời ba nhà đâu ừ đập. Khoảng nhà quê bạn.	1	0	57	100	2023-08-12 19:28:53	2023-12-09 01:07:50.12972
24	Đỏ tô xanh yêu khâu mười sáu. Mua đã trời bè nước. Đá ừ chìm nước.	1	0	45	11	2023-10-03 04:36:52	2023-12-09 01:07:50.131801
25	Leo thế độc chết thế trời. Tím bạn đồng thế lầu. Tô trời thuê tủ em ừ.	0	0	14	10	2023-07-07 14:24:11	2023-12-09 01:07:50.134862
26	Tui thích viết ghế. Lỗi mười hàng bàn. Vàng năm ừ lầu.	1	0	30	8	2022-12-24 09:58:04	2023-12-09 01:07:50.136993
27	Độc độc tám. Thương viết con ghét đánh đạp phá yêu xe. Tô thì tàu việc không.	0	0	3	96	2023-07-20 23:39:39	2023-12-09 01:07:50.13885
28	May biết hết. Con nón là thích quê hương lỗi vàng tàu yêu. Bơi may trăng biết hai mười nghỉ may em mười.	1	0	89	8	2023-03-01 13:53:27	2023-12-09 01:07:50.141756
29	Dép ruộng biết trăng nhà trời nón thuyền tôi. Trời bàn đánh chết cửa làm xanh năm. Lầu tám leo thích hương con quần nón tủ.	1	0	52	51	2023-11-07 01:13:04	2023-12-09 01:07:50.144023
30	Ruộng cửa thôi tô ờ đâu quần. Đồng hóa hai chết nón. Máy vá giày bè xanh viết ngọt.	1	0	52	36	2023-05-13 04:49:57	2023-12-09 01:07:50.148478
31	Hai thì ác đánh. Hóa chết đâu. Dép bạn bạn viết.	1	0	66	4	2023-09-11 10:59:09	2023-12-09 01:07:50.151084
32	Viết thôi cái mua á. Vá khoảng một thế khoảng trăng nghỉ. Vàng ruộng yêu xuồng mua đồng may.	1	0	62	19	2023-05-16 05:47:12	2023-12-09 01:07:50.153155
33	Trời đã em đang á một núi. Xanh đồng ừ khâu bạn chết đá bàn đạp chết. Chín biết ruộng máy bạn đánh hóa.	1	0	54	10	2023-03-18 07:30:25	2023-12-09 01:07:50.155042
34	Khoảng khoảng tôi quê. Bốn mượn may đập ngọt chết nha xe việc. Núi chỉ sáu gì xuồng mượn bơi tàu tui hương.	1	0	59	29	2023-11-08 13:57:59	2023-12-09 01:07:50.156944
35	Viết ba tím mười. Ruộng mua đá tím hàng. Kim hết may năm gió cửa quần.	0	0	47	63	2023-07-31 02:03:19	2023-12-09 01:07:50.15858
36	Quần mượn chìm gió bàn. Nón leo đá trăng. Vẽ thôi hết xe.	1	0	46	64	2023-04-22 07:55:29	2023-12-09 01:07:50.160263
37	Tôi làm đỏ may đánh xuồng cửa. Hết mây leo ờ cửa ngọt tui. Vá mượn xuồng lỗi biết yêu đang năm em nghỉ.	1	0	96	52	2023-01-22 13:52:44	2023-12-09 01:07:50.162006
38	Hương đá thích tui lỗi nghỉ. Tôi lầu áo làm một trời chín xe đã thôi. Thuyền sáu đánh máy ghét.	0	0	88	55	2023-08-21 23:07:35	2023-12-09 01:07:50.163564
39	Quê hóa vá tô không thuê mượn hết bạn á. Thế chín bàn biết chín lỗi ờ ác chín. Hương nón vàng hóa nhà đạp đạp nghỉ tô mây.	0	0	93	21	2023-06-24 07:05:56	2023-12-09 01:07:50.165164
40	Khoan lầu viết bơi biển. Khoảng nón áo tàu vẽ. Năm nước mây biết giết.	0	0	62	26	2023-08-03 11:49:24	2023-12-09 01:07:50.16674
41	Tô ác vẽ mượn biển. Lỗi xanh ác xanh á thương ác lầu. Hàng cửa khâu làm giết chết nghỉ ghế lỗi.	1	0	99	51	2023-03-20 05:52:30	2023-12-09 01:07:50.168615
42	Em yêu chết phá em ghế núi trời anh cửa. Hóa ghét khoan biển. Cửa mướn á ừ thuyền.	0	0	97	13	2022-12-26 17:49:15	2023-12-09 01:07:50.170249
43	Độc việc tím tím thuyền tím tím tám. Vẽ trời bảy nước tôi ghét quần lỗi tám trời. Độc phá quê biển mây con đã thôi.	1	0	86	33	2023-03-09 11:39:04	2023-12-09 01:07:50.172035
44	Ừ ác chìm. Đập tím đánh áo vàng biết dép tủ bạn. Đạp viết lỗi tôi lầu được.	0	0	43	24	2022-12-18 16:24:37	2023-12-09 01:07:50.173758
45	Mười nghỉ quần tàu ruộng mượn thương lỗi hương. Nón xuồng con sáu đang vẽ không. Nón gì đạp thương.	1	0	61	23	2023-08-16 02:27:23	2023-12-09 01:07:50.175624
46	Tô bảy ghét tui vá tám chín. Giết hàng bơi nhà giày chìm leo cửa tím ừ. Núi yêu tủ may.	1	0	59	54	2023-09-12 15:32:40	2023-12-09 01:07:50.177364
47	Xuồng hết yêu quần. Mua đánh tàu quê xe bơi. Xanh chỉ sáu khoan nha ghét lỗi làm thuyền.	1	0	55	38	2023-02-04 13:35:55	2023-12-09 01:07:50.179063
48	Xanh độc thuê cái trăng. Nghỉ lầu thuê. Dép em bốn đồng nước hết đang bè ba chết.	1	0	31	71	2023-06-21 16:11:58	2023-12-09 01:07:50.180497
49	Quần không ba đánh trăng là đang tám máy quê. Nha ngọt cửa lầu bốn á. Bè chết không kim lỗi việc nước ờ con.	0	0	49	13	2023-07-28 23:21:25	2023-12-09 01:07:50.182185
50	Vàng ờ lầu làm không hóa áo độc giày. Nước năm á mây đâu mây yêu chết mướn. Nước leo giày ừ khâu hương được lỗi nha áo.	0	0	78	85	2023-05-24 22:39:22	2023-12-09 01:07:50.183738
51	Đồng đánh bốn mướn xuồng gió. Kim là xe đạp mười nhà ác hương. Hàng thuyền ba ruộng mây viết áo tím.	0	0	98	39	2023-09-27 22:37:33	2023-12-09 01:07:50.185718
52	Tàu con tàu mây thuyền tám là là núi. Viết con ừ dép ngọt khoảng đồng bè anh. Vẽ ác leo bè một thuyền.	1	0	69	60	2023-11-14 07:18:12	2023-12-09 01:07:50.18753
53	Một làm trăng dép khoan nước đồng đập hàng nước. Gì bàn leo. Chết đã mây quê tô việc mượn mượn nước.	1	0	59	9	2023-05-08 13:22:56	2023-12-09 01:07:50.189123
54	Việc phá em thuyền kim là làm thích gì trăng. Đã nghỉ xanh dép vá á. Thì bốn nha phá đỏ đạp tôi mua chìm kim.	1	0	55	73	2023-08-14 19:26:32	2023-12-09 01:07:50.190754
55	Đồng đá tàu năm leo vá việc bạn quần. Bạn thuê xanh em đá em hết nón việc nhà. Thuê ruộng hàng đánh xe tàu đỏ ngọt nghỉ tô.	1	0	6	9	2023-08-11 07:35:24	2023-12-09 01:07:50.192332
56	Vá mua con hóa. Anh giết lầu tím. Mua quê nghỉ sáu tủ.	1	0	91	99	2023-09-20 04:31:31	2023-12-09 01:07:50.194073
57	Xe độc biển cái hết. Lỗi vá đá yêu bốn ba chỉ đỏ thuyền. Khoảng mua anh tô thôi chìm gió.	1	0	35	54	2023-09-06 23:23:31	2023-12-09 01:07:50.195619
58	Xuồng sáu yêu sáu bơi. Áo tô một mây viết. Bè mây hương yêu.	0	0	85	72	2023-01-23 06:13:22	2023-12-09 01:07:50.197299
59	Gì yêu tui là. Mây thương giết gió yêu tô biết tủ tủ. Làm áo hóa.	1	0	66	87	2023-05-22 03:38:35	2023-12-09 01:07:50.198821
60	Khâu á tôi vá đang em đá. Bàn là đã. Mây ác cửa.	0	0	28	37	2023-05-26 03:10:11	2023-12-09 01:07:50.200285
61	Bơi con sáu tàu áo tô máy. Trời trăng giày. Bốn đang bàn.	0	0	45	56	2023-05-27 19:59:54	2023-12-09 01:07:50.20178
62	Bốn kim hóa chết vẽ vẽ chín á. Đang hết máy ruộng chìm là hóa nón bạn anh. Lỗi hương khâu ghét ghét hai.	0	0	56	38	2023-04-15 05:06:22	2023-12-09 01:07:50.203201
63	Mây chín ác yêu áo ba. Là đỏ xanh nước. Anh anh chỉ bảy thì bạn hương thuyền mượn không.	0	0	6	16	2023-02-20 23:27:29	2023-12-09 01:07:50.204674
64	Vàng chìm quần mua tủ nha mượn biển hóa. Vá xe biển hết bàn. Bè bè phá bốn đỏ.	1	0	26	51	2022-12-10 11:16:36	2023-12-09 01:07:50.206223
65	Ngọt xuồng quần bàn. Năm em đánh được lỗi gió ghét là độc. Đồng việc leo ghế là cửa ờ.	0	0	83	7	2023-01-21 12:43:35	2023-12-09 01:07:50.207917
66	Lầu phá thôi nhà nha một đồng đồng vàng. Bè ghế con. Anh núi đâu tui.	1	0	17	68	2023-03-28 08:11:57	2023-12-09 01:07:50.209425
67	Hóa mướn khoảng chín thôi bạn xanh tám. Tàu yêu khâu phá ba trời hết thế. Ừ ác sáu thích yêu lỗi một.	0	0	59	41	2023-05-23 12:00:31	2023-12-09 01:07:50.210916
68	Mượn em thuê mượn biển xanh máy vẽ là. Ác mượn chỉ bốn mua á đạp ác chìm tím. Em thuyền nha trăng mua ác.	0	0	31	21	2022-12-14 17:57:03	2023-12-09 01:07:50.212603
69	Leo đã làm thích máy hương thôi. Đâu là thuê gì đập trăng ngọt viết hai mây. Khoảng chết con ừ hương.	0	0	31	14	2023-07-22 02:39:26	2023-12-09 01:07:50.21411
70	Con em một áo tủ may đâu núi em tôi. Ờ đồng chết viết chìm độc độc kim. Nghỉ giết năm.	1	0	29	84	2023-06-16 01:51:34	2023-12-09 01:07:50.215816
71	Hương biển chỉ thích hai hai tô. Xanh thương thuê bốn vàng gì. Vá vàng khoan phá.	0	0	60	4	2022-12-31 17:09:18	2023-12-09 01:07:50.217383
72	Biển ngọt đánh đập là xe anh. Biết giày tôi xe. Dép bàn một kim nón tui được nước tủ.	1	0	29	45	2023-05-16 19:11:39	2023-12-09 01:07:50.218985
73	Hết ngọt độc quê nón chỉ vá chết phá lỗi. Nha yêu hết đánh hai. Độc ba thuê giày ghét vá.	0	0	67	76	2023-12-04 09:09:37	2023-12-09 01:07:50.220593
74	Dép hết hết tô nón hương. Bàn ngọt mười. Nghỉ vẽ bốn hóa.	1	0	70	20	2023-11-10 00:31:31	2023-12-09 01:07:50.222261
75	Vá thuê giày không tím tôi giày tàu bơi. Cái đang vàng một ừ gió ngọt ác năm. Biển làm thôi lầu.	1	0	29	64	2023-02-04 14:41:36	2023-12-09 01:07:50.223797
76	Leo đạp quê. Thương leo nha. Trăng giết thì đạp anh ừ máy đạp sáu.	1	0	25	77	2023-01-15 02:13:44	2023-12-09 01:07:50.225313
77	Là mua thì. Viết độc thôi tàu. Độc bàn vẽ sáu may ác đá bè.	0	0	19	59	2023-01-22 08:26:27	2023-12-09 01:07:50.226988
78	Vẽ lầu thích leo ghế tô nón khoảng. Thế thế thuê thì tô. Chết áo sáu đang anh khoan được lầu thương gió.	0	0	65	2	2023-03-10 20:32:35	2023-12-09 01:07:50.228606
79	Độc thuê đâu chìm giết ác việc biển. Ngọt lỗi cái áo tô thích năm xanh làm hóa. Trăng đỏ đập.	1	0	92	31	2023-03-17 00:50:38	2023-12-09 01:07:50.230086
80	Bè bè ba quê ruộng phá. Kim mượn lỗi thích trời sáu. Vàng thế tám vẽ gì tôi ghế biển đá.	0	0	56	57	2023-06-03 06:20:32	2023-12-09 01:07:50.231728
81	Đạp xe tui tui chết không tô sáu tui. Ác đang quần thuê mười gió là. Em gì tàu.	1	0	77	75	2023-09-27 16:43:29	2023-12-09 01:07:50.233393
82	Nghỉ á hai sáu mua bàn. Đồng bè kim. Áo chìm ác tôi xanh ác hàng yêu thích.	1	0	92	88	2023-07-18 09:27:33	2023-12-09 01:07:50.235003
83	Xanh cái quần tím ác. Đâu bạn lầu thuyền nước nha bơi hết. Đánh máy nha anh.	1	0	99	16	2023-06-29 16:36:47	2023-12-09 01:07:50.237787
84	Tàu giày độc khoan việc máy gió hết tôi ừ. Chết đâu đập đập ờ khâu xe lỗi leo sáu. Quê kim chín máy biển ghế đang nước biển phá.	1	0	74	66	2023-01-09 12:23:52	2023-12-09 01:07:50.241157
85	Con xanh yêu. Lỗi chỉ ác tôi biển bè quần đang ghét. Khâu biển đâu mây nón gió xe vá anh.	1	0	74	5	2023-10-08 09:36:39	2023-12-09 01:07:50.244309
86	Đã con bốn mướn. Máy được tôi đâu ác. Á hóa thuê khâu quần trời dép đạp.	1	0	36	67	2023-09-06 21:56:26	2023-12-09 01:07:50.24739
87	Thuyền đâu đồng. Tui xuồng đỏ bàn bảy mướn đồng đang giết. Nha hàng nha hai tàu mười.	1	0	2	73	2023-09-07 14:44:42	2023-12-09 01:07:50.250922
88	Nha giết đâu. Mượn bè phá vàng ngọt chín vẽ. Xe giày đập bè đồng chết mây.	1	0	90	35	2023-07-30 17:18:52	2023-12-09 01:07:50.254028
89	Dép thương biển dép. Tôi thương vá á ờ lỗi tím. Việc núi cái vẽ đỏ hóa đạp.	0	0	34	49	2023-07-13 17:00:40	2023-12-09 01:07:50.25714
90	Giết ghét đã. Năm vẽ vẽ phá bảy leo quần hết tàu. Đạp khoảng vàng một ngọt việc tám trăng.	0	0	88	80	2023-11-05 18:16:40	2023-12-09 01:07:50.260236
91	Viết trời mây gì. Tám quần năm em. Lỗi chết cửa không núi mây.	1	0	80	34	2023-03-09 08:51:23	2023-12-09 01:07:50.263888
92	Nước áo vá thuê. Hóa nghỉ đánh. Vàng hàng nước hai bàn máy mượn đang ghế thôi.	1	0	47	64	2023-07-23 12:56:02	2023-12-09 01:07:50.266963
93	Tủ tui bảy. Vàng viết viết kim thích nha tui. Mười khoảng ghế ba là đỏ tím bạn.	0	0	37	80	2023-04-28 11:57:06	2023-12-09 01:07:50.269092
94	Cái năm đá đâu gió. Vá cửa hết quần mây em thế ghét chìm vàng. Nhà phá việc.	1	0	70	13	2023-05-04 08:36:46	2023-12-09 01:07:50.271812
95	Quê máy phá á một quần hương. Mướn cái cửa đá nhà sáu ghét leo ừ mướn. Bè đạp ngọt.	0	0	93	53	2023-11-16 06:50:46	2023-12-09 01:07:50.275047
96	Cửa gì lỗi giày. Đã cửa là quê thì bạn được nón giết ác. Mướn biển khoảng bạn gió.	0	0	57	39	2023-04-22 06:38:27	2023-12-09 01:07:50.278406
97	Biển leo chết. Ghế đánh núi vàng nghỉ nghỉ bảy. Vẽ hai quê anh nón thích.	0	0	3	34	2023-09-23 09:36:56	2023-12-09 01:07:50.281527
98	Kim là đá xanh tô thì con tô mượn bàn. Ờ đồng xuồng là xuồng. Hóa hóa bốn.	1	0	27	75	2023-01-25 10:08:53	2023-12-09 01:07:50.283691
99	Đâu năm tím. Ờ mây bảy. Chìm thì thì hàng bảy việc.	0	0	50	74	2023-11-13 03:16:17	2023-12-09 01:07:50.286437
100	Nhà khâu mua máy ghế gió là viết. Nước là máy. Bàn mây leo.	1	0	20	95	2023-02-05 20:36:41	2023-12-09 01:07:50.288562
\.


--
-- Data for Name: question_likes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.question_likes (id, questionid, userid) FROM stdin;
\.


--
-- Data for Name: question_notifications; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.question_notifications (id, senderid, recipientid, questionid, url, content, hasread, createdat) FROM stdin;
\.


--
-- Data for Name: question_tag; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.question_tag (id, tagid, questionid) FROM stdin;
\.


--
-- Data for Name: questions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.questions (id, title, content, isanonymous, viewcount, likecount, userid, acceptedanswerid, createdat, updatedat) FROM stdin;
1	Chỉ là thế cửa con mướn hai nhà sáu em.	Bàn năm xanh mua mười mua. Quê được được ghét. Gì việc núi gió biết á.	1	26	0	28	\N	2023-02-26 19:52:46	2023-12-09 01:07:49.906261
2	Chín ngọt đâu hóa biết nghỉ vàng.	Hương xanh đánh quê. Biển kim leo đá ngọt may leo. Mua xanh thôi giết con anh.	1	25	0	32	\N	2023-04-12 01:14:49	2023-12-09 01:07:49.909024
3	Một ngọt núi tui xanh biết hàng đồng thương tủ.	Mười cửa vàng bốn việc. Giày cái năm núi tím chìm tui hóa. Mây tô quê nhà không mượn thuyền kim thì khâu.	1	85	0	49	\N	2023-09-04 16:00:13	2023-12-09 01:07:49.910815
4	Vá không đang đá dép lầu biết.	Dép biết phá bơi đạp thuê. Đánh tui đá phá ờ đang thuê. Ba phá mười mượn.	1	54	0	85	\N	2023-02-27 12:18:50	2023-12-09 01:07:49.9127
5	Chỉ bơi mười.	Gì lỗi một tám đánh. Chín lầu năm áo. Chín em mướn mượn xuồng thôi ác khoan.	1	90	0	89	\N	2023-10-17 07:12:30	2023-12-09 01:07:49.914705
6	Mua bè sáu thương ghét ác đồng nước cửa.	Á làm bảy viết tàu máy tím gió vá. Mua một nón ghét máy. Xuồng lầu núi tám.	0	20	0	2	\N	2023-10-09 11:51:37	2023-12-09 01:07:49.9168
7	Tôi ruộng bốn.	Bốn mua năm vàng việc tàu độc nghỉ mướn. Xanh độc anh đỏ. Mây nhà may tui bàn tàu xe mười ừ hai.	1	78	0	17	\N	2023-09-05 06:54:56	2023-12-09 01:07:49.918647
8	Bàn đập đập khoảng quần trời giày bàn giày năm.	Độc áo máy ờ biển ngọt tím việc. Giày giết khâu. Sáu đỏ khâu ghét gió nón mướn em mua.	1	92	0	53	\N	2023-08-27 23:24:28	2023-12-09 01:07:49.920432
9	Hai đạp đỏ.	Là thương leo tủ hóa hóa hóa. Mười sáu một cửa đánh kim trăng núi. Núi khoan mây thương xuồng độc tôi viết thuyền.	1	67	0	87	\N	2023-05-07 22:35:51	2023-12-09 01:07:49.922606
10	Yêu tui thương yêu bạn gió.	May sáu chìm gì hàng ruộng biết hai ba. Sáu mua gì bè thế giết. Con tàu áo thích.	0	17	0	6	\N	2023-05-02 13:13:40	2023-12-09 01:07:49.924572
11	Leo vẽ em.	Đánh đạp ghét em. Ghế một bốn kim hương chín cửa mua biết đang. Hết tui hàng.	1	39	0	9	\N	2023-07-09 22:23:48	2023-12-09 01:07:49.926374
12	Một dép chín đồng thuyền đánh.	Khoan quần mười. Mượn máy anh lỗi hóa ác. Được vàng không tám núi hết.	1	48	0	56	\N	2023-04-11 11:52:48	2023-12-09 01:07:49.928248
13	Khoan chìm tôi biển tám mua vẽ.	Cái áo nha thương. Á hóa phá biết kim phá chỉ mượn. Việc chỉ bơi ác.	1	8	0	60	\N	2023-08-05 20:04:00	2023-12-09 01:07:49.930053
14	Bơi cái thôi thế thuyền thuyền.	Phá cửa khoảng ngọt con đánh hai đỏ á tui. Gì chết mướn thì thuê leo. Ngọt chín bơi hàng chỉ thế bè ruộng.	1	33	0	84	\N	2023-01-11 01:35:08	2023-12-09 01:07:49.931752
15	Bàn vá viết hóa xe tôi đang dép.	Một hóa xe giết. Vá thương anh leo tám dép độc may gió đánh. Nón đang vá gì đã tô biết giết dép.	0	71	0	59	\N	2023-08-04 03:58:15	2023-12-09 01:07:49.933373
16	Quê đang làm thương thì viết hóa thế.	Mướn hương đã ghét chết nón trời được bàn chín. May giết dép kim mướn chín em. Lỗi ừ tôi nhà mây việc trăng yêu tàu ờ.	0	40	0	36	\N	2023-06-16 11:43:23	2023-12-09 01:07:49.935038
17	Vàng chỉ không ác xanh bạn yêu thuyền ờ.	Xe mượn mười được vá độc thích. Máy nhà khâu xuồng. Được ờ trời.	1	0	0	54	\N	2023-05-29 22:24:21	2023-12-09 01:07:49.93677
18	Áo độc chỉ hai tủ đã gió yêu á đánh.	Nón may tím bạn nghỉ. Đã làm chỉ. Vàng hương bè khoảng may giết.	0	95	0	93	\N	2023-11-22 03:32:08	2023-12-09 01:07:49.938314
19	Làm khoan thế biển lỗi may.	Chết sáu bốn. Hương đạp giết thuê chìm hương. Bạn bốn đang nha thương đỏ cửa lỗi sáu con.	1	10	0	90	\N	2023-11-09 20:49:56	2023-12-09 01:07:49.939923
20	Quê áo biển đỏ đập tủ tủ đá thuê.	Dép áo năm tủ nha khoảng trăng nước tám. Anh vàng quê bơi hương. Ruộng là leo mười nón đã yêu thuê viết thương.	1	10	0	23	\N	2023-06-21 19:25:42	2023-12-09 01:07:49.94172
21	Hóa hóa ruộng nghỉ máy em thế trăng.	Được bàn tám giày bốn đạp mướn. Quê hàng bạn xe. Ruộng thế anh nước viết chìm được lầu nước.	1	7	0	90	\N	2023-05-17 13:02:47	2023-12-09 01:07:49.943415
22	Đỏ nha khoảng khoảng ruộng hóa vàng.	Một trăng dép. Đâu yêu bơi nha vẽ. Gì đồng may tui ruộng ghế dép.	1	4	0	13	\N	2023-11-17 11:31:43	2023-12-09 01:07:49.945163
23	Trời bè leo mua là gió đang xuồng.	Bảy thôi thế nha. Bốn hóa năm trăng bốn gió nha được sáu không. Giết bảy hết thích làm ngọt máy.	1	18	0	32	\N	2023-06-14 07:35:02	2023-12-09 01:07:49.946817
24	Cửa thương anh biết mượn viết ruộng phá.	Hàng đánh năm sáu bàn bảy độc nón thuyền. Mướn bạn khoảng viết thuê. Núi tô kim là chỉ.	1	65	0	8	\N	2023-08-17 14:46:11	2023-12-09 01:07:49.94834
25	Mua xuồng đồng đánh phá đỏ vàng áo trăng nhà.	Đánh chín mua. Đập kim tím. Khoảng nha thì anh xuồng xanh.	0	6	0	60	\N	2023-11-21 17:49:14	2023-12-09 01:07:49.950002
26	Nhà may biển lỗi mua chìm tám biển.	Quê đá năm viết khoan nhà. Đạp vá chết ờ đánh bơi ngọt xanh. Ngọt một độc nón bảy xuồng cái tô vàng.	1	75	0	94	\N	2023-08-12 09:45:00	2023-12-09 01:07:49.951612
27	Không chín năm thích quê tô tôi.	Đá năm đã đã vá anh. Ừ xanh đỏ sáu năm biết quần. Biển trăng viết xuồng mười.	1	55	0	47	\N	2023-10-12 05:48:29	2023-12-09 01:07:49.953074
28	Đánh mười vá tui bơi đã trăng.	Bàn hai viết con tàu làm tôi thuyền ba vẽ. Lầu chín xe chết đồng đồng hương quê bốn một. Hai biết quê xanh áo em hương quê.	1	1	0	89	\N	2023-06-08 14:25:26	2023-12-09 01:07:49.954606
29	Thuyền xanh ruộng vàng.	Bạn cái mười chết mượn bảy bàn ác ruộng. Giày vẽ hóa leo. Anh tàu mướn tàu tô biển mướn.	0	1	0	16	\N	2023-05-16 10:17:56	2023-12-09 01:07:49.956455
30	Ghế việc tím chỉ đá ác.	Vẽ thuê việc bốn đâu. Ác sáu chết lầu xe tàu. Áo mua đá đâu ờ đang.	1	38	0	17	\N	2023-06-12 17:17:44	2023-12-09 01:07:49.958062
31	Áo tui thuyền đồng vá hết đánh viết là việc.	Viết ừ thế đập. Thế lầu chết xanh tím làm đang vàng á. May đỏ bàn.	1	79	0	87	\N	2023-02-21 13:13:48	2023-12-09 01:07:49.959743
32	Sáu vàng nhà biển khoảng.	Đồng tô ừ mượn may thuê dép hương. Ruộng đá con sáu gió máy ờ yêu ờ mượn. Khoảng nước nghỉ chìm nghỉ bạn tím ừ.	0	52	0	11	\N	2023-05-12 15:01:08	2023-12-09 01:07:49.961353
33	Kim xanh thì mua.	Leo đỏ bạn đã em ghế thuyền xe mây. Khâu thì biển. Lầu tôi thích đạp mướn thuê một thuê thích viết.	0	13	0	54	\N	2023-07-23 19:10:53	2023-12-09 01:07:49.962971
34	Hai biển trăng tôi giết.	Xanh lầu giết máy ghế. Lầu vẽ cái vá mây nha hàng ngọt. Anh giết ruộng bốn áo thuyền mây.	0	95	0	71	\N	2023-02-13 05:50:06	2023-12-09 01:07:49.964604
35	Áo mua xuồng độc tàu lỗi việc kim đánh đập.	Tui gì khoảng thế nhà phá bạn ừ yêu. Xe mướn gì mây mười hàng ruộng làm. Hương đỏ thương cái đạp.	0	95	0	70	\N	2023-02-19 23:01:03	2023-12-09 01:07:49.96606
36	Ngọt cái tủ mây làm cửa tui chìm.	Vẽ ác em tô làm em. Thôi bè xe chết giết cửa. Thế nón ba thuê khoảng mười giết con được.	1	23	0	27	\N	2023-08-10 08:35:46	2023-12-09 01:07:49.967864
37	Vá thích tui chết cái tàu giày máy giày.	Kim ác hóa biển chỉ đồng tám thế giết á. Hai đập kim nghỉ. Bốn á ác làm giết trăng.	1	67	0	5	\N	2023-04-21 06:08:26	2023-12-09 01:07:49.969876
38	Yêu anh nước biết giày kim năm đập dép khâu.	Giết mướn mướn á núi đỏ bốn thôi đá. Mướn lỗi tám giày lầu ghét khoan yêu. Hương đánh hai làm.	0	1	0	64	\N	2023-09-14 11:08:27	2023-12-09 01:07:49.971766
39	Vàng đồng đâu đánh nước vá quần không vá.	Lầu được không đánh làm leo bè bè nón đập. Năm chỉ mượn hàng bốn đồng giết một xe. Đánh thuê thuê sáu may khoảng đang vẽ mượn chìm.	0	80	0	58	\N	2023-11-07 03:28:44	2023-12-09 01:07:49.973306
40	Xuồng nón em giày thích phá xuồng quê thôi.	Xuồng núi làm ác vẽ quê. Đỏ thôi việc xe lầu tôi tô nón gì. Máy gió thương em may.	0	68	0	88	\N	2023-10-17 01:43:26	2023-12-09 01:07:49.974831
41	Thuê kim leo tui tím là gió lỗi hết.	Trăng ừ biết thôi đánh tám dép chìm thôi. Giết hương cái leo chết. Chìm tô được ghế dép.	0	26	0	73	\N	2023-02-10 05:29:43	2023-12-09 01:07:49.976388
42	Thuyền xuồng biển viết vẽ máy đạp chết tui bàn.	Gió bơi mười chỉ. Đỏ tôi thế chết. Con lỗi ác bốn nha bè đánh việc.	1	47	0	71	\N	2023-08-16 22:21:59	2023-12-09 01:07:49.978208
43	Đồng đập đã tím chìm bốn.	Giết tám không bè bảy xe gió anh ba tàu. Thương được bảy mây đã hai. Giết tủ nghỉ biết ác mây núi.	0	36	0	85	\N	2023-06-06 04:11:55	2023-12-09 01:07:49.979971
44	Chìm đã mua ác thuyền đâu gió đánh một xanh.	Khoảng ác đang thế được leo. Hai gió hai ngọt đâu tủ sáu cái. Làm á yêu xe quần đã bơi.	1	11	0	95	\N	2023-01-16 05:00:31	2023-12-09 01:07:49.981525
45	Bạn gì gió nón mây xuồng biết leo.	Tui tôi ờ ngọt ruộng nghỉ viết. Khâu tàu ghế chết một quê ruộng đang kim. Con ba quần.	0	84	0	81	\N	2023-12-01 05:24:32	2023-12-09 01:07:49.98298
46	Gì hóa giày.	Sáu đỏ con thương. May mây đập thôi đạp vá ruộng. Đập đồng làm tàu lỗi.	0	86	0	77	\N	2023-04-18 02:14:06	2023-12-09 01:07:49.984746
47	Núi nghỉ tàu vàng xuồng tám lỗi giày.	Chín bơi em việc hóa mướn giày khoan cái. Đồng thích chết áo núi bốn viết yêu. Tàu mười thì tám thích quê tàu hương.	1	83	0	92	\N	2023-01-09 04:05:17	2023-12-09 01:07:49.986385
48	Thuyền bè nghỉ mượn gió máy đánh thế bè.	Tui đâu vá. Bạn may chết bè tô thôi. Đập đồng bảy thì.	1	98	0	41	\N	2023-05-06 03:08:33	2023-12-09 01:07:49.988388
49	Tô khoảng một chín.	Bàn đã thuê năm bốn đập hết giết hai. Gì xanh xe. Ghét hết ngọt thì tô đồng chết.	1	49	0	75	\N	2023-10-03 05:19:47	2023-12-09 01:07:49.990672
50	Mua đánh một trời tô.	Đồng ruộng máy cái. Ba đâu chín em đạp đã là. Đồng ruộng khâu ờ.	1	58	0	12	\N	2023-11-02 04:37:06	2023-12-09 01:07:49.992936
51	Hóa anh ba.	Mua trăng tủ. Tàu núi trời bè anh mượn đồng. Đỏ trời đá vẽ ngọt áo.	1	53	0	68	\N	2023-06-08 17:53:17	2023-12-09 01:07:49.994867
52	Phá hương anh đã đỏ chín tím gì đồng.	Làm thích ruộng xe mua lỗi bàn tôi mua. Thôi vàng con xuồng vá mười vàng xanh. Mây làm được.	1	2	0	53	\N	2023-10-19 11:06:20	2023-12-09 01:07:49.996859
53	Bơi dép đá lỗi đã biển.	Hương mướn tàu bốn không hóa. Thuyền giết được vá hóa gì thích đâu. Được mua chìm.	1	54	0	57	\N	2023-06-03 15:18:17	2023-12-09 01:07:49.998985
54	Mua em yêu xanh không ruộng may đạp nghỉ phá.	Nha gió đã khâu chìm. Thuyền tui lỗi bạn trăng thì thuyền đã nghỉ. Bảy lầu ừ anh.	1	89	0	49	\N	2023-05-13 03:12:19	2023-12-09 01:07:50.000924
55	Bơi chín vá.	Sáu khâu em. Gió mướn máy trăng. Xanh không khâu ba tô độc.	1	76	0	65	\N	2023-03-30 03:40:37	2023-12-09 01:07:50.002831
56	Ngọt ba đá bàn chìm tôi ừ trăng.	Thế ghét ghét đang. Chìm trăng em hương thôi. Thì lỗi ruộng gì mướn được thôi tám tôi quê.	1	35	0	52	\N	2023-07-27 16:30:20	2023-12-09 01:07:50.004606
57	Biết ruộng thích á em việc tôi xuồng.	Lỗi quần biết nón hàng giết. Ghét một bảy ruộng thương á. Hết tím mua biển khâu yêu được vá.	1	12	0	29	\N	2023-10-24 02:42:39	2023-12-09 01:07:50.006842
58	Nước thuê tôi anh.	Xanh máy mướn thôi xanh thế khâu. Bạn bơi cửa độc khoan làm tôi quê đỏ áo. Máy tám leo bè tàu.	1	93	0	55	\N	2023-10-06 09:35:44	2023-12-09 01:07:50.008598
59	Khâu thôi không tôi kim lầu giết lỗi thương.	Mây trăng nón ba ngọt gì vẽ làm sáu năm. Máy áo thuê. Ba mua núi.	1	21	0	94	\N	2023-02-20 02:36:03	2023-12-09 01:07:50.010188
60	Mây lỗi tủ bơi.	Đập vẽ máy đỏ chết thương ác gió. Thì thuyền áo vá. Hóa chết bạn ừ tôi.	0	87	0	43	\N	2023-07-05 06:43:46	2023-12-09 01:07:50.012064
61	Ghế mua đánh đánh.	Vẽ á thôi hóa vẽ thế quần. Tủ một hết thuyền anh quần nghỉ bơi. Gì ruộng hàng.	0	0	0	99	\N	2023-10-09 09:23:59	2023-12-09 01:07:50.013981
62	Ác mây làm biển leo.	Chín quần anh vẽ đá ruộng tám thuê yêu sáu. Kim vẽ anh đập. Thì chìm cái.	1	28	0	88	\N	2023-07-13 13:25:20	2023-12-09 01:07:50.015816
63	Ừ đá hàng áo mua.	Trăng đạp hai chín. Tám thuê ba dép mượn. Trời yêu đạp thích ngọt mười xe.	1	3	0	3	\N	2023-04-25 15:56:10	2023-12-09 01:07:50.01756
64	Thuyền ngọt tui xe hóa ừ.	Ngọt bàn ghét đạp bảy không. Hàng lầu trăng giết quần. Dép ghế hết nhà hết làm.	0	69	0	2	\N	2023-05-24 09:34:08	2023-12-09 01:07:50.019621
65	Tàu đánh trời mua đập nón giày.	Bảy cái núi. Lầu nhà tôi quần lỗi hương đã ghế mượn. Biển thích thế viết ác ba.	0	98	0	62	\N	2023-07-20 05:05:46	2023-12-09 01:07:50.02139
66	Ba hàng giết thôi cái chết hương xanh tàu giết.	Hàng tàu ghế em mua ba mây anh thích em. Lỗi ác cửa. Trăng tô quê bốn lầu.	1	43	0	50	\N	2023-09-06 17:29:06	2023-12-09 01:07:50.02296
67	Ghét đạp nhà mây.	Chết sáu nha bè mua giày con. Giết em phá bạn tàu tôi phá đánh đang trời. Thế không bơi tàu tím nhà ghế ghét.	0	56	0	51	\N	2023-06-10 19:00:18	2023-12-09 01:07:50.024901
68	Tím ác xe nhà năm cửa đá vàng mướn.	Nón làm hết hương quần đồng may quần. Thôi lầu thuyền cửa đá. Mướn một ừ đá phá bàn bàn xuồng cái hết.	1	57	0	37	\N	2022-12-31 19:43:40	2023-12-09 01:07:50.026824
69	Xuồng xe yêu hai đã đâu.	Mây nón biết một khoảng nha may. Chỉ yêu á tàu thế mười đỏ đồng bè. Gì cái á hóa đạp đạp tui ngọt chỉ sáu.	1	93	0	44	\N	2023-10-06 18:55:33	2023-12-09 01:07:50.028867
70	Đã thôi khoan nhà hương.	Núi chết ghế mây thuê thuyền mượn tô biết. Độc giết không tím việc biết biết trời. Phá trời mua ờ cửa thế.	1	54	0	80	\N	2023-10-13 06:28:32	2023-12-09 01:07:50.030991
71	Cửa áo núi năm ừ tô được bạn nha chín.	Tôi chín bốn. Máy thì tô ác ghế bơi chín đá. Mười em thuyền đỏ chỉ lầu.	1	98	0	66	\N	2023-05-31 14:37:13	2023-12-09 01:07:50.033069
72	Việc ba độc chết ờ vẽ hóa.	Lầu vàng bảy cửa. Đá ba em thôi hóa đạp khoảng độc leo. Gì giết chín xuồng cái làm.	0	27	0	99	\N	2023-08-17 16:47:32	2023-12-09 01:07:50.035108
73	Thì viết tô gió ruộng mướn ba chìm năm hóa.	Leo biển áo mướn. Tàu xe tím bảy viết đập hai tủ khoan. Bảy lầu may hai mượn.	1	28	0	14	\N	2023-02-12 13:03:46	2023-12-09 01:07:50.037265
74	Hết lầu đạp vẽ được là ừ.	Ghế sáu con. Em thuê nón làm em độc ruộng. Lầu chỉ gió.	1	77	0	10	\N	2023-07-19 21:39:04	2023-12-09 01:07:50.039189
75	Nón biết lầu hai thương hai xuồng áo.	Gì bàn bạn một mượn chết gì ghét. Phá độc đỏ quê may đánh tủ leo mướn. Chỉ viết em khoảng á ngọt biết ngọt.	1	30	0	3	\N	2023-10-30 10:08:23	2023-12-09 01:07:50.041339
76	Không nha bốn nhà bạn.	Á việc vá thuê làm. Ghế đã ác. Bốn chìm lầu xe hóa.	1	32	0	99	\N	2023-02-02 13:10:23	2023-12-09 01:07:50.04331
77	Giết đá nước hai đâu giày.	Bè một thì một thuê bơi. Mượn tủ anh phá mướn vẽ mây giày thích thích. Khâu đập chết giày nghỉ núi áo.	1	27	0	63	\N	2023-05-08 02:16:27	2023-12-09 01:07:50.045433
78	Đồng đập em máy.	Quê giày trời đâu bè bơi là. Mướn chín tô xanh mười leo em hai thế. Biết biển ruộng.	1	19	0	97	\N	2023-09-22 18:51:41	2023-12-09 01:07:50.047336
79	Con gió thuyền thì thuê là khâu xe.	Khoan xe việc giết. Á ba lỗi biển. Phá yêu đá mướn thôi cái gì.	0	25	0	27	\N	2023-02-24 18:14:47	2023-12-09 01:07:50.049366
80	Đâu chìm sáu việc hết chìm không mượn sáu.	Ngọt trời thế đồng giày là tôi hai. Nước bè chết bè. Thì đạp xuồng thế gió.	0	51	0	64	\N	2023-04-21 18:51:57	2023-12-09 01:07:50.051299
81	Mây nhà ừ ruộng thế gì chết.	Được cái tô tôi khâu ngọt khoảng nón. Ờ bơi gì. Nước thuyền đá.	1	10	0	71	\N	2023-02-17 00:39:50	2023-12-09 01:07:50.053189
82	Núi nghỉ được may giày bàn tám tàu.	Làm nha đá mua mướn đỏ cửa xanh hai thích. Độc viết thương thôi tủ độc cái mười. Một cửa không tím chết năm nha.	0	78	0	68	\N	2023-03-06 11:22:29	2023-12-09 01:07:50.055169
83	Vá kim một.	Mua không nghỉ. Dép á một cái cái. Máy chìm tàu nhà tàu tô tui quê ghế.	1	20	0	76	\N	2023-11-09 21:22:04	2023-12-09 01:07:50.057123
84	Đồng là tủ.	Khoan con đâu thích trăng. Mượn tui bốn đâu áo. Chỉ vá lầu anh chìm áo ngọt hết tôi bảy.	0	65	0	85	\N	2023-02-16 04:06:00	2023-12-09 01:07:50.059036
85	Ờ trời giết không leo.	Cái bè ờ đập. Đâu ghế áo cái cửa khoan lỗi. Kim vàng nha.	1	20	0	76	\N	2023-01-27 00:40:16	2023-12-09 01:07:50.061152
86	Hết leo đã.	Ờ ghế núi đã. Em mượn quê sáu độc khâu bè lỗi tô ghế. Quần hương ngọt biển tôi nha lỗi bạn hết.	1	81	0	86	\N	2023-03-28 18:25:03	2023-12-09 01:07:50.063144
87	Vá nước may nhà thích độc là bàn.	Tô ghét bè leo đỏ. Đỏ bè khoảng ừ bè. Lỗi quần quê tôi ừ ghét.	0	55	0	11	\N	2023-06-16 05:03:48	2023-12-09 01:07:50.064961
88	Không ác xe ngọt bạn thuê hóa tô bàn việc.	Một con biển biết thuyền làm thôi kim tui khâu. Đá thì mượn đạp ác thuê dép em. Không việc việc trời viết làm.	1	41	0	56	\N	2023-02-26 12:01:42	2023-12-09 01:07:50.06709
89	Anh kim đạp ừ mười xe.	Con nước không vàng được. Xanh nhà đá hết bè. Nha lỗi khâu bè mượn thôi ruộng cửa.	0	36	0	80	\N	2023-02-04 18:10:34	2023-12-09 01:07:50.069043
90	Bè mua dép lỗi.	Xe mướn bơi mướn á xanh mướn không. Hàng hết khâu. Đâu được tui bảy.	0	13	0	31	\N	2023-11-24 03:45:12	2023-12-09 01:07:50.07084
91	Năm con gió thuê bốn giết ba giết áo.	Cái năm hương khoan đồng. Á chỉ thuyền gió. Tím tám gì hai đạp.	1	62	0	51	\N	2023-09-23 12:46:55	2023-12-09 01:07:50.072568
92	Nha cửa thôi tui quần.	Nha lầu vá. Biển chìm nón máy ghế tàu đánh tàu. Leo lỗi bốn sáu đã ghét mướn.	1	67	0	9	\N	2023-10-09 10:57:37	2023-12-09 01:07:50.07435
93	Đang tủ dép.	Vẽ chỉ mười là đang nón không mười. Hương con chìm khoảng chín. Là không tám lỗi tím.	1	88	0	100	\N	2023-01-28 04:07:11	2023-12-09 01:07:50.076286
94	Việc thế áo.	Thế đạp yêu ruộng ba mượn vá viết trời chín. Được đang sáu. Nghỉ hương xe á chết anh thuyền độc.	0	78	0	58	\N	2023-04-19 14:18:33	2023-12-09 01:07:50.078017
95	Anh thôi may bơi bốn tôi hai.	Hết vẽ là. Làm cái đá vẽ khâu hóa không. Xanh thuê ruộng khâu.	0	28	0	9	\N	2023-03-11 04:52:23	2023-12-09 01:07:50.079853
96	Mua việc gió.	Hương trời đập trăng năm. Tôi trời bốn thương ghét. Vàng thuyền mười một ghét hóa sáu ngọt việc.	1	3	0	20	\N	2023-02-28 03:12:13	2023-12-09 01:07:50.081647
97	Nghỉ ruộng đánh.	Đánh trời hết mười may. Ừ hương tui phá dép cửa đỏ đâu tô chín. Tím tôi áo.	1	54	0	92	\N	2023-07-01 23:52:12	2023-12-09 01:07:50.08332
98	Mướn đạp tám.	Đã khoảng leo được đang. Một cửa bè sáu tám mười chết mua đỏ chín. Bảy là đâu may bàn biển tám đỏ.	0	42	0	97	\N	2023-06-14 19:07:34	2023-12-09 01:07:50.084981
99	Á ác mây hết cái tàu tàu không việc.	Đỏ đâu hàng. Biển một áo khoan gì máy. Đỏ xuồng chín kim.	1	53	0	85	\N	2023-08-25 21:07:04	2023-12-09 01:07:50.086646
100	Mua phá thuê không đạp núi đập vẽ bàn một.	Đồng đá vá em nhà bạn. Đập được bàn hàng áo hết hàng cửa bơi con. Thôi ba thích bè chỉ hàng biết.	0	31	0	65	\N	2023-04-03 22:12:53	2023-12-09 01:07:50.088456
\.


--
-- Data for Name: tags; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tags (id, tagname, count, color) FROM stdin;
1	bơi	95	#7d0364
2	tím	50	#721a79
3	sáu	91	#40292e
4	hai	29	#6c6344
5	vàng	81	#0d0c7f
6	nón	6	#1b5c70
7	mây	20	#7e2d00
8	khoảng	35	#3f6041
9	xe	51	#585f74
10	bốn	62	#591d78
11	á	71	#07531b
12	thuê	70	#4a2941
13	cửa	35	#0c7e4f
14	sáu	71	#6b2654
15	thôi	72	#26515a
16	mướn	19	#2e2115
17	ngọt	26	#57240a
18	kim	49	#41287d
19	không	28	#317a7f
20	ngọt	26	#7b5e0f
21	khâu	71	#49285b
22	khâu	74	#1d310f
23	yêu	90	#752e38
24	không	27	#295f4c
25	cửa	42	#2c7c72
26	thôi	85	#69131a
27	mua	88	#3d120d
28	khoảng	98	#5e6d6b
29	bơi	100	#210f29
30	tôi	58	#693925
31	mười	78	#09133f
32	gió	95	#617f80
33	đập	93	#56727a
34	mây	17	#0f3143
35	ruộng	73	#77117f
36	thích	30	#64303b
37	đã	94	#54330f
38	đâu	39	#14767d
39	bè	60	#640e1c
40	hàng	16	#492172
41	bảy	82	#5b3b3b
42	thuê	49	#4c0816
43	hai	43	#7d6f14
44	leo	71	#22695a
45	quần	20	#0f660e
46	đánh	15	#55380d
47	mượn	21	#1b1e13
48	đã	44	#7b381c
49	đạp	30	#0e327d
50	bốn	99	#5e2441
51	thích	47	#0f6f30
52	nghỉ	63	#703c61
53	làm	84	#43762f
54	thế	43	#163f41
55	vá	89	#67707a
56	ghế	60	#263b7f
57	đánh	83	#107339
58	đỏ	80	#3e495f
59	giết	3	#36571e
60	mua	73	#1f0360
61	xe	9	#686223
62	tủ	12	#747f04
63	khâu	82	#6a6649
64	ờ	83	#76251e
65	giết	97	#784b57
66	nón	15	#153530
67	núi	59	#154778
68	là	65	#794861
69	con	50	#0f6446
70	sáu	68	#6a3d6b
71	bốn	64	#435d42
72	làm	87	#065b03
73	đã	56	#077e35
74	đạp	70	#3b505e
75	vẽ	7	#18462c
76	viết	35	#345c51
77	sáu	87	#04642e
78	tám	50	#6c4c54
79	độc	97	#7b1b26
80	dép	8	#7d4a16
81	núi	34	#266841
82	nghỉ	85	#5a4621
83	làm	84	#15774e
84	nhà	31	#630b6f
85	biển	6	#501653
86	là	46	#31657f
87	trời	85	#56647c
88	mướn	10	#56154c
89	đánh	13	#3c762a
90	được	18	#010060
91	cửa	26	#195761
92	bè	66	#2c3b05
93	bạn	31	#0e1d41
94	giết	100	#375652
95	trăng	30	#525f42
96	thuyền	27	#6e3c7e
97	chết	92	#4e2a33
98	nhà	34	#0d5626
99	đồng	1	#00132c
100	yêu	43	#7e2f4f
\.


--
-- Data for Name: user_tokens; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_tokens (id, user_id, token, expiration_date, created_at) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, fullname, password, email, reputation, gender, dateofbirth, avatarurl, studentid, class, school, schoolyear, aboutme, ispublic, createdat, updatedat) FROM stdin;
1	Viễn Thông Trương	RvX5D_UKTwQs9i3	BaoChau_Lam@hotmail.com	100	1	2023-02-17 22:08:07	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/195.jpg	20204511	nhà	biển	tím	Thuê gì bơi đang mua đạp tím. Trăng chìm mướn bảy xe. Tím đạp biết.	1	2023-12-09 01:07:49.655216	2023-12-09 01:07:49.655216
2	Thiên Lan Dương	AoNXjE4hSBbcJje	QuangThuan96@gmail.com	62	0	2023-07-14 20:58:00	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/1175.jpg	20224447	cửa	quần	nón	Biết khâu núi hương việc vẽ ngọt. Được ừ bè tui con đồng đạp bơi tám. Quê nghỉ đâu tím thương đỏ nhà bảy áo ngọt.	0	2023-12-09 01:07:49.660116	2023-12-09 01:07:49.660116
3	Hữu Khoát Đoàn	q_0H99gotIjxT7c	SongKe_Tang@gmail.com	45	1	2023-12-07 17:56:04	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/388.jpg	20157049	bốn	tủ	thuê	Yêu đạp trăng núi vàng. Nhà ghét đạp yêu lầu. Ghế quê tím bảy gì cửa.	0	2023-12-09 01:07:49.664144	2023-12-09 01:07:49.664144
4	Ánh Trang Vương	t0UK2nk_itO8G4a	NhanTu_Le53@gmail.com	27	0	2023-04-01 09:16:04	https://avatars.githubusercontent.com/u/60783710	20162825	trời	quần	dép	Đánh nhà đạp một quê. Hóa chết em may. Hàng bảy cửa khâu thôi mười đánh.	1	2023-12-09 01:07:49.667427	2023-12-09 01:07:49.667427
5	Tài Nguyên Vũ	ClQ28VI5RJk_3Xk	Thanh7kat_7koan@gmail.com	57	0	2023-09-02 08:16:19	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/363.jpg	20158430	làm	vàng	một	Là không tàu thương. Biển quần một leo gió chỉ tàu chín đâu. Bảy lỗi tím máy ờ xanh.	0	2023-12-09 01:07:49.671316	2023-12-09 01:07:49.671316
6	Yến Anh Đỗ	xpEIkUQD3lVnMNq	7kacCuong51@yahoo.com	42	1	2023-10-27 11:04:29	https://avatars.githubusercontent.com/u/10453124	20168001	dép	được	khoan	Cửa may thuyền bơi. Chỉ viết tui hóa. Nhà là con nước kim chỉ đồng bơi.	0	2023-12-09 01:07:49.673596	2023-12-09 01:07:49.673596
7	Cát Cát Vương	gxVhYeBMXlTSsoh	QuangThach.Ly96@yahoo.com	1	1	2023-08-15 20:07:06	https://avatars.githubusercontent.com/u/25387397	20172009	tàu	biết	ghế	Một hóa ghét tui ghét. Bạn anh trời đá ác núi được thì ừ vàng. Leo độc trời biết được hết thôi bàn áo ghế.	1	2023-12-09 01:07:49.677388	2023-12-09 01:07:49.677388
8	Thế Dân Phan	Hk9pE4TgjLXWg3I	DuyTiep.Ha@yahoo.com	71	1	2023-01-16 20:52:02	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/1218.jpg	20162964	mua	tủ	cái	Trời xanh tui xanh. Bốn xuồng em á. Thì lỗi năm ghế ngọt khoan lầu.	1	2023-12-09 01:07:49.680892	2023-12-09 01:07:49.680892
9	Huyền Trang Nguyễn	mZLwkjtPowjC91n	MongLan.Phan84@gmail.com	12	0	2023-04-07 07:29:17	https://avatars.githubusercontent.com/u/18593953	20211333	ruộng	chín	chìm	Mây thương đồng lỗi lỗi giết chỉ. Ác ghế nón con chết thôi mua. Máy tàu yêu ngọt mây lỗi xe tám nước.	0	2023-12-09 01:07:49.684409	2023-12-09 01:07:49.684409
10	Vân Ngọc Tô	lfszvOGAD1fYa2G	ThanhThien_Tran56@yahoo.com	90	0	2023-01-21 10:08:14	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/411.jpg	20187778	hết	tàu	thì	Chết ba đâu sáu. Viết không xanh nước. Em không ba quê mười gió tô tô vá gì.	0	2023-12-09 01:07:49.687828	2023-12-09 01:07:49.687828
11	Thế Vinh Đinh	W2NoFZwluPDpZhC	DanHiep87@yahoo.com	48	0	2023-01-21 08:09:07	https://avatars.githubusercontent.com/u/60343272	20165691	xanh	chìm	thế	May khâu gì hóa năm đạp bàn thích. Viết chìm khoảng nha giết được đang sáu. Thôi bơi á.	0	2023-12-09 01:07:49.691249	2023-12-09 01:07:49.691249
12	Minh Toàn Trịnh	i2VS6CRS5j5gkXs	Thuy7kao.Lam@gmail.com	39	0	2023-08-14 11:43:09	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/906.jpg	20238616	trời	ghét	thích	Đập núi mây. May chín biết nước tám thế áo bốn chín. Xanh ba trăng thương nước tàu ừ.	1	2023-12-09 01:07:49.693513	2023-12-09 01:07:49.693513
13	Quang Tài Lê	B6Z3uKwxpIJyCSZ	TuyetLoan.Duong84@gmail.com	50	1	2023-07-21 11:40:32	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/1050.jpg	20195720	vàng	đỏ	ruộng	Kim tôi ừ trời viết vẽ ừ lầu nghỉ tím. Khoan đang giày. Dép năm dép việc bạn xe đồng ghế hàng nước.	1	2023-12-09 01:07:49.697231	2023-12-09 01:07:49.697231
14	Nhật Lệ Phan	n2336v1WJ4N22lg	HuongTra_Pham@gmail.com	52	0	2023-04-25 05:06:48	https://avatars.githubusercontent.com/u/4405463	20222246	không	nón	trăng	Đỏ nha giày làm hóa ngọt mua giết giày ờ. Hết á quần đỏ. Biển xe á quê hóa đạp đạp quần bạn.	0	2023-12-09 01:07:49.699685	2023-12-09 01:07:49.699685
15	Đông Phong Ngô	mEiJKSvtsBPWmwv	ThuYen.Ho91@gmail.com	47	1	2023-05-14 16:47:19	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/252.jpg	20207535	đang	chìm	hết	Đá tô việc viết khoan hai. Bảy tám khâu không bơi máy. Bạn tám biển bè khoan em đỏ á núi.	1	2023-12-09 01:07:49.702615	2023-12-09 01:07:49.702615
16	Thu Loan Tăng	ufILnvOe3O18zz9	ThanhThanh10@hotmail.com	63	0	2023-03-06 20:55:41	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/367.jpg	20220408	trăng	năm	hàng	Đồng lỗi thì thế mướn. Thì anh tàu giết đỏ. Hương núi ác bốn biết tím.	0	2023-12-09 01:07:49.706223	2023-12-09 01:07:49.706223
17	Bích Liên Trần	V7XAeS90VYIivZX	TamLinh.Hoang@yahoo.com	81	0	2023-03-14 23:47:10	https://avatars.githubusercontent.com/u/42538879	20178225	giày	tôi	xuồng	Gì vẽ ngọt nghỉ bốn ghế nha hết. Tám tui độc giết hết. Làm ba con ba tủ anh sáu khâu.	0	2023-12-09 01:07:49.709439	2023-12-09 01:07:49.709439
18	Bích Thu Vũ	kY8rN1S2FIiXXww	HienChung_Hoang@yahoo.com	58	1	2022-12-22 04:08:11	https://avatars.githubusercontent.com/u/38964445	20196561	mượn	giết	thương	Thích nhà nghỉ. Quần núi viết nước. Tô nha mây xe lỗi một em tím gió.	1	2023-12-09 01:07:49.713084	2023-12-09 01:07:49.713084
19	Quốc Thiện Trương	PW3mBJYt2MSdPBU	MyLe17@yahoo.com	97	1	2023-12-08 06:52:29	https://avatars.githubusercontent.com/u/85877058	20225266	bạn	vẽ	đánh	Nghỉ khoan ba mây thôi đá khoan hàng yêu. Dép xanh vàng không quần hàng không thế. Tím ừ khoan quần mướn.	0	2023-12-09 01:07:49.71647	2023-12-09 01:07:49.71647
20	Khắc Việt Đoàn	Hv64dm0RiVxH3l_	DaNguyet.Vuong46@gmail.com	69	1	2023-01-28 03:36:11	https://avatars.githubusercontent.com/u/92306477	20143667	máy	tàu	gió	Thương ngọt tám. Áo đã đạp lỗi vàng. Đập ghét ba đá anh bốn hương tím giết.	1	2023-12-09 01:07:49.719797	2023-12-09 01:07:49.719797
21	Mai Thanh Hà	bo6z5K2baS6A8Hv	BaoQuoc48@yahoo.com	44	0	2023-11-15 22:25:09	https://avatars.githubusercontent.com/u/71533826	20140288	mướn	áo	năm	Hai em mua vá được mướn vàng máy đập khâu. Đồng áo bơi ngọt tám giết xanh kim chìm. Bàn một thế lỗi năm một đánh không thì yêu.	1	2023-12-09 01:07:49.723001	2023-12-09 01:07:49.723001
22	Nhật Minh Dương	LYJW5XhUsleRV2j	NgocTuan.Truong@yahoo.com	94	0	2023-07-31 12:27:44	https://avatars.githubusercontent.com/u/13994951	20140746	tô	thôi	xanh	Hương nhà hóa tôi đạp thì xanh bơi núi đỏ. Đỏ mây tô máy là kim. Mười bơi tui giết đã nha thuyền năm.	0	2023-12-09 01:07:49.726314	2023-12-09 01:07:49.726314
23	Bạch Cúc Vương	8DRCCNjX4_s8Yd3	LienHuong94@hotmail.com	76	1	2023-11-10 05:39:42	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/442.jpg	20169407	bơi	mười	ừ	Tàu ờ chín hàng em một ghế. Nha lầu hàng bè mua hai đâu. Viết nón ác quê ba đồng đang yêu trời.	1	2023-12-09 01:07:49.729433	2023-12-09 01:07:49.729433
24	Hạ Phương Phan	BhzdpoKBruO43ca	LanPhuong2@yahoo.com	58	1	2023-04-27 07:49:59	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/362.jpg	20163544	đập	cửa	biển	Nghỉ ác khâu đạp biển ba. Khoan tám lỗi. Tô giết con hết nha.	0	2023-12-09 01:07:49.733134	2023-12-09 01:07:49.733134
25	Phong Độ Tăng	ueTY3zSCUDXNS7N	HueLan_Phan@gmail.com	12	1	2023-02-11 22:20:15	https://avatars.githubusercontent.com/u/3529212	20142248	bạn	chết	đập	Trăng được bơi may mướn cửa xe may hết yêu. Tôi mượn kim hàng mượn ngọt trời bàn thế ngọt. Anh trời tô đâu quần mua máy thuê tủ xanh.	0	2023-12-09 01:07:49.736659	2023-12-09 01:07:49.736659
26	Duy Cường Đinh	SX3SOGKGdAAhvQ5	NgocThuan.Phung@yahoo.com	24	0	2023-03-06 20:57:18	https://avatars.githubusercontent.com/u/33599962	20185622	may	ghét	máy	Ghế bốn xuồng sáu ba đâu máy trăng. Tủ con mượn thuyền một đồng. Bè xuồng đâu mướn chỉ hương ngọt ác.	1	2023-12-09 01:07:49.740143	2023-12-09 01:07:49.740143
27	Hòa Giang Phan	frQdEWD_YVs3cqf	ThaiTan_7kang@hotmail.com	46	0	2023-04-26 23:48:14	https://avatars.githubusercontent.com/u/83252220	20161378	nha	nước	thôi	Chìm ừ hương thuê đánh xuồng việc ờ. Nghỉ ba vá thuê ghế đồng việc nhà. Yêu hàng lỗi hàng.	0	2023-12-09 01:07:49.742175	2023-12-09 01:07:49.742175
28	Thu Trang Trần	6p2ctfF_20oe9X1	BaoAnh_Truong44@hotmail.com	23	0	2023-04-28 16:31:37	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/297.jpg	20226393	ghét	mướn	bàn	Bơi biết nghỉ cửa vá đạp được thích thì. Lầu xanh một. Tủ bè ờ giết.	0	2023-12-09 01:07:49.745187	2023-12-09 01:07:49.745187
29	Bá Trúc Vũ	zizUlxfkVe6XoFA	LamNhi_Tran39@yahoo.com	62	0	2023-08-28 02:28:11	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/1070.jpg	20229902	hàng	hết	ừ	Thuê nhà đã xe núi bảy đạp áo. Bạn leo nhà anh chín dép ghế nha. Áo áo xe bảy bạn đập tím.	0	2023-12-09 01:07:49.747402	2023-12-09 01:07:49.747402
30	Thùy Giang Vương	afY8Oz6XaWAo7dX	ThaiMinh.Truong@gmail.com	37	1	2023-01-22 16:26:30	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/976.jpg	20141296	hương	ngọt	độc	Được tủ đánh nhà thôi khâu. Chìm ruộng leo cửa gì ghế. Đâu ghét trăng lỗi thuyền mây.	0	2023-12-09 01:07:49.750794	2023-12-09 01:07:49.750794
31	Hạnh Linh Trần	ucNEykIc9NQZLfb	ThanhTrung.Lam@yahoo.com	62	1	2023-09-27 23:34:56	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/1018.jpg	20161629	chết	ờ	trăng	Ba biết con đá ruộng đồng tôi vàng việc. May nước đã bàn chín tôi quê đồng hàng. Gì hương tủ vàng việc đâu đã quê trời đã.	1	2023-12-09 01:07:49.75405	2023-12-09 01:07:49.75405
32	Quốc Hoài Hà	XLii0NIT1TFVv5C	ThanhHuy89@yahoo.com	77	1	2023-08-24 21:01:10	https://avatars.githubusercontent.com/u/67178350	20179725	hai	ruộng	thuyền	Mây chỉ thuyền biển vá phá. Khâu thích được phá. Thì giày ác ác bảy em.	1	2023-12-09 01:07:49.756211	2023-12-09 01:07:49.756211
33	Thúy Nga Tăng	uEWOgw_NmVK0IEu	GiaKien.Hoang@gmail.com	64	1	2023-05-11 15:01:31	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/436.jpg	20141225	tủ	khâu	máy	Áo núi máy xe lỗi phá cái mây hóa. Nón nghỉ ác thuê núi dép. Trăng giày ngọt.	0	2023-12-09 01:07:49.759101	2023-12-09 01:07:49.759101
34	Vân Phi Hà	P3h0HUftYNnsIg0	ThanhTrang.7koan@hotmail.com	41	0	2023-02-27 13:21:51	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/542.jpg	20212795	mượn	tủ	xe	Mười ừ một lỗi. Cửa biết thương khoan không chìm tô chín. Thương một ngọt.	0	2023-12-09 01:07:49.761289	2023-12-09 01:07:49.761289
35	Đức Khiêm Hà	sn8iB8pHrWcrPZD	ThienPhuoc_Nguyen65@yahoo.com	37	0	2023-09-01 11:26:50	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/791.jpg	20157746	một	máy	hết	Ba đánh á một đỏ ba ờ. Thương nghỉ là lầu ngọt mướn tím nước thuyền. Tám khâu mượn vẽ thôi bơi đâu phá thế.	1	2023-12-09 01:07:49.763366	2023-12-09 01:07:49.763366
36	Đắc Lộ Tăng	_8fhKdXahE1aMmy	ThuyVan4@gmail.com	3	1	2023-01-06 21:19:15	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/71.jpg	20177369	chìm	năm	việc	Bè ba may núi. Đã tám biết núi phá hương bảy nhà bạn. Mượn hai biển tàu anh trời thuê.	1	2023-12-09 01:07:49.766422	2023-12-09 01:07:49.766422
37	Hữu Chiến Vũ	Pf031lgfGYlukcf	ThuLien_Bui@hotmail.com	95	1	2023-10-13 01:50:09	https://avatars.githubusercontent.com/u/58719370	20149434	yêu	quần	đã	Đỏ xuồng ruộng bốn. Đâu thương nha dép trời mười bàn ghế. Trời mười chỉ quần đồng mướn biển.	1	2023-12-09 01:07:49.76872	2023-12-09 01:07:49.76872
38	Thúy Loan Vũ	yX92s3j3s4Y5S9w	ThaiHa.Pham@gmail.com	16	0	2023-03-10 06:51:58	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/278.jpg	20148293	ờ	đã	thôi	Quê nón giết mướn. Anh tô may nước tám khâu. Tô ghét giết làm.	1	2023-12-09 01:07:49.770872	2023-12-09 01:07:49.770872
39	Khắc Minh Đặng	zAFz05x9Knp8llt	XuanYen57@yahoo.com	17	0	2023-06-20 14:42:31	https://avatars.githubusercontent.com/u/49388150	20159322	ba	xanh	đạp	Đập gì giết. Hàng mượn biết xe giày xe khâu. Trời trăng mười máy độc.	0	2023-12-09 01:07:49.772864	2023-12-09 01:07:49.772864
40	Khánh Văn Đỗ	z4ZwsqLX3WaXgMk	DieuHuong_7kinh2@gmail.com	62	1	2023-02-24 00:04:11	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/248.jpg	20145424	nha	quê	được	Leo tám đá hương hết bè bốn. Mười ruộng thương lỗi ừ tám mượn ngọt. Chết thì đã biết tím bảy.	1	2023-12-09 01:07:49.774753	2023-12-09 01:07:49.774753
41	Trúc Phương Đinh	f0OcJOV1MnlA8hW	Tu7kong88@gmail.com	56	0	2023-11-22 19:58:11	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/713.jpg	20161730	chìm	nước	được	Nhà đang tàu quần trăng ngọt chỉ xe. Ruộng tám hương. Đá đá thuê ác chết thế.	1	2023-12-09 01:07:49.776912	2023-12-09 01:07:49.776912
42	Thùy Mi Đỗ	KTBj0AaQ7vQarbd	MinhVu_Ngo@gmail.com	48	0	2023-05-28 14:42:36	https://avatars.githubusercontent.com/u/74638786	20188553	thôi	cái	làm	Ngọt lỗi trời khoan bơi chìm không thì quần thương. Chỉ chỉ bốn trăng thôi. Thích may đồng yêu cái bảy chín.	0	2023-12-09 01:07:49.779085	2023-12-09 01:07:49.779085
43	Minh Hỷ Đoàn	wAPzHZB4zQkruSy	ThucUyen.Trinh@hotmail.com	82	0	2023-10-25 10:24:32	https://avatars.githubusercontent.com/u/78463132	20167189	được	vàng	chín	Máy xanh bơi làm bơi thích áo giết tui thì. Nghỉ xanh vàng nón xe được. Trời núi đá việc nha ừ ngọt.	0	2023-12-09 01:07:49.781102	2023-12-09 01:07:49.781102
44	Tiểu My Phan	Ec3J8uKeJy99Mn3	LeChi78@gmail.com	59	1	2023-11-05 18:57:12	https://avatars.githubusercontent.com/u/78483914	20234481	lỗi	năm	năm	Thì biển mây mua. Tủ nón núi xe trời nghỉ. Đạp làm bốn mướn đánh kim nón xanh tô.	1	2023-12-09 01:07:49.783204	2023-12-09 01:07:49.783204
45	Vương Triều Trương	ADUSFwpQFA_LMt_	SongLam.Tran49@yahoo.com	42	1	2023-02-07 00:42:52	https://avatars.githubusercontent.com/u/74146219	20177224	cửa	khoan	hàng	Hết đá anh xanh lỗi nón vá. Vẽ hàng chín anh tím vẽ khoan thuyền được bàn. Giết ờ đã yêu con viết một quê nón.	1	2023-12-09 01:07:49.785366	2023-12-09 01:07:49.785366
93	Anh Thi Trần	SmpOyIBH7KN5Xrt	HuyAnh70@gmail.com	21	0	2023-01-12 02:35:11	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/7.jpg	20176960	tủ	lỗi	đang	Bảy trăng nghỉ. Vá đang con. Kim quê quê ngọt đá nhà.	0	2023-12-09 01:07:49.889509	2023-12-09 01:07:49.889509
46	Phương Nhi Vương	skXbIT67smekZ1E	NhatHoa46@hotmail.com	78	1	2023-12-05 06:41:27	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/935.jpg	20143533	yêu	đánh	xanh	Đạp biết quần ghét con bạn gì. Nón cái thôi tủ mướn cái áo gió chết. Ruộng hai đập chết thôi trăng.	0	2023-12-09 01:07:49.787825	2023-12-09 01:07:49.787825
47	Túy Loan Phạm	xhmbqU1GOBEw2j9	ThaiSan_7kang@gmail.com	95	0	2023-06-28 00:11:59	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/1040.jpg	20195458	hóa	thì	được	Việc là cửa không ngọt. Nước hai chết mua bốn một. Đồng tô đập khoan may leo mây.	0	2023-12-09 01:07:49.790428	2023-12-09 01:07:49.790428
48	Kim Xuân Đặng	_Nim5TsamS0GwAL	7kinhLuan69@gmail.com	72	1	2023-10-10 16:41:50	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/801.jpg	20222253	tám	con	thuê	May nha vẽ xuồng hương. Hương bàn đạp đập. Hóa ác quần cái cửa chìm thương khoảng.	1	2023-12-09 01:07:49.79253	2023-12-09 01:07:49.79253
49	Vân Quỳnh Tăng	ed2JRyHRPkVhmdR	QuynhTram47@yahoo.com	89	0	2023-10-18 19:09:10	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/816.jpg	20233447	bạn	vẽ	dép	Giết trăng may. Ghét ghét xe bè giết. Ruộng ừ bàn tủ hàng phá dép làm chìm ờ.	1	2023-12-09 01:07:49.794562	2023-12-09 01:07:49.794562
50	Kiều Loan Tăng	41xDAOEi1FIvple	ThienTinh_Nguyen34@gmail.com	22	1	2023-06-29 01:04:51	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/838.jpg	20177238	là	cái	hết	Đập xe đồng. Ghét thuyền lầu máy. Nghỉ thích ừ anh là biển ba bảy đập.	0	2023-12-09 01:07:49.796589	2023-12-09 01:07:49.796589
51	Quỳnh Dao Trần	USK3dkjByuqjLl9	NamHung34@gmail.com	90	1	2023-05-04 13:37:22	https://avatars.githubusercontent.com/u/99352896	20204597	bảy	gì	tám	Tám máy một. Đâu đánh biết ừ bè thuyền leo ghét. Thích nước thuê con mướn nước.	1	2023-12-09 01:07:49.798526	2023-12-09 01:07:49.798526
52	Thế Phúc Đỗ	IkVqXqmH_NFRrUb	LongQuan68@yahoo.com	7	0	2023-08-01 15:51:37	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/385.jpg	20230186	thuyền	mười	hàng	Trời thế bè chìm hết. Thích lầu bốn năm đỏ mượn ba độc. Năm á leo vẽ khoảng bè.	1	2023-12-09 01:07:49.800425	2023-12-09 01:07:49.800425
53	Thanh Phong Đào	TTZPFZfrjrV5ZEJ	HongHa.Vuong99@gmail.com	93	1	2023-02-10 03:55:36	https://avatars.githubusercontent.com/u/10984996	20172137	viết	khoan	độc	Xanh cửa mười bè sáu quê ngọt cái anh thôi. Vẽ tôi hai núi đánh. Tàu thôi bạn tui giết biết.	0	2023-12-09 01:07:49.802511	2023-12-09 01:07:49.802511
54	Bình Minh Mai	sPOz0pTKBsvKBBu	NgocDung_To8@yahoo.com	96	0	2023-03-16 10:45:39	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/700.jpg	20218980	xuồng	bạn	phá	Trăng ngọt bè mua hóa. Ác anh trăng áo ruộng đâu. Được một yêu vàng biết.	1	2023-12-09 01:07:49.804619	2023-12-09 01:07:49.804619
55	Lâm Vũ Hà	PfGjy7strGBe1vp	MinhHai_Ho16@yahoo.com	81	1	2023-05-16 16:26:22	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/1212.jpg	20165430	leo	bạn	leo	Mướn hóa yêu sáu biết giết đã. Hết ác tàu được bơi. Bốn may tui chết đã anh leo đã bảy.	1	2023-12-09 01:07:49.806524	2023-12-09 01:07:49.806524
56	Giang Sơn Vũ	rEcW1aCA6fdqfK3	HaiBinh71@gmail.com	36	1	2023-07-28 09:18:15	https://avatars.githubusercontent.com/u/66329540	20180278	làm	lỗi	đạp	Nón leo tủ máy. Biển tô mua ghế bạn tôi. Quần giết đang.	0	2023-12-09 01:07:49.808415	2023-12-09 01:07:49.808415
57	Tuyết Thanh Hồ	3zRom3dhCzGcUvL	NghiQuyen_Ngo@hotmail.com	44	1	2023-10-03 21:56:37	https://avatars.githubusercontent.com/u/38689820	20177713	tám	vá	áo	Viết phá cái bảy làm một ruộng yêu. Năm đã đâu lầu. Ác làm lầu anh hàng.	0	2023-12-09 01:07:49.810437	2023-12-09 01:07:49.810437
58	Quang Hải Đỗ	AlE4lqwd2rMnncW	ThuyTram37@hotmail.com	94	0	2023-08-27 02:45:35	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/1070.jpg	20188114	hai	trời	cửa	Đánh xe áo. Hết hàng gì việc. Ba hương ờ đâu chết viết dép là thuyền làm.	0	2023-12-09 01:07:49.812732	2023-12-09 01:07:49.812732
59	Tất Bình Phạm	dL2pxjF56fbjjMP	HuuNghi_Ha@hotmail.com	39	0	2023-08-16 15:39:12	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/533.jpg	20230115	ác	bạn	mượn	Xe đang ruộng ba thế gì. Tô giày biển làm chìm đâu núi quê trời. Năm quần thuê biết quê nghỉ.	0	2023-12-09 01:07:49.814726	2023-12-09 01:07:49.814726
60	Duyên Nương Phùng	xtDrkSrWghzEadb	PhuongTam.Hoang50@hotmail.com	38	1	2023-01-21 12:42:08	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/877.jpg	20141780	chìm	bảy	hàng	Mướn thuê biết mượn em hóa ừ á máy con. Máy vẽ đồng áo tôi hóa vẽ sáu đánh. Hết xuồng ghế núi viết máy.	1	2023-12-09 01:07:49.817084	2023-12-09 01:07:49.817084
61	Đức Trí Dương	JDad1jtHVQyxtg4	QuynhLam_7ko@hotmail.com	96	1	2023-11-17 22:33:54	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/720.jpg	20232167	đập	cái	áo	Leo không nha. Chỉ biển trời sáu tám nước hàng làm ờ. Viết cửa mua mướn không vá núi khoan tôi một.	0	2023-12-09 01:07:49.819548	2023-12-09 01:07:49.819548
62	Phương Phương Đỗ	K3TfJD97DNHFiya	Thong7kat_Tran@hotmail.com	95	1	2023-05-14 07:41:44	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/873.jpg	20213944	quần	bơi	xe	Tàu xe đâu. Thế khâu ghế hàng vàng vá. Giày năm đạp việc.	1	2023-12-09 01:07:49.821636	2023-12-09 01:07:49.821636
63	Phước Thiện Phan	fYmlKAXLY23Lyhx	HaiChau66@yahoo.com	12	1	2023-05-24 13:49:35	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/1163.jpg	20185760	kim	quần	kim	Giết quê đang. Bạn nón cái lỗi. Bảy đỏ đạp gió quần.	1	2023-12-09 01:07:49.824011	2023-12-09 01:07:49.824011
64	Trúc Mai Trịnh	ggjBTWXZiHTSe0H	TieuQuynh.Trinh@hotmail.com	25	0	2023-11-17 07:35:52	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/370.jpg	20163970	anh	ghét	biết	Giết hai phá hương dép bơi hàng. Áo vàng tui mây ruộng giết khoảng đang nhà. Thế anh biết ờ đánh thích anh.	0	2023-12-09 01:07:49.82628	2023-12-09 01:07:49.82628
65	Công Luận Tô	4Cu225n11ijDdLi	LocUyen12@yahoo.com	70	1	2023-08-17 05:45:35	https://avatars.githubusercontent.com/u/3911112	20238800	mười	anh	xe	Gì độc khoảng tám đạp quê đá. Máy giày á hết. Gì ờ chìm bơi em ghế kim ác giết.	1	2023-12-09 01:07:49.830075	2023-12-09 01:07:49.830075
66	Hiếu Giang Đào	I30C_uqjnU7VZuD	7kinhHuong_Pham@gmail.com	73	1	2023-08-06 03:08:30	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/548.jpg	20181873	mười	độc	thuê	Năm hai chết viết dép. Đập hai thuyền đâu anh không hàng nhà thì. Sáu cái giày trời vẽ ruộng.	1	2023-12-09 01:07:49.832369	2023-12-09 01:07:49.832369
67	Bích Lam Đặng	obie7QDTz0a1nUS	LinhLan_Duong@hotmail.com	72	1	2023-05-04 20:19:20	https://avatars.githubusercontent.com/u/6191554	20170521	thuê	quê	hai	Hai áo nhà được chìm leo thế bảy gì cửa. Hai tô biết đang bảy đá ruộng. Thế phá hết mua thì việc là được ghế hương.	1	2023-12-09 01:07:49.834074	2023-12-09 01:07:49.834074
68	Thúy Hường Nguyễn	47D8vUBFYAnxPDu	GiaCan5@hotmail.com	17	1	2023-10-05 08:18:51	https://avatars.githubusercontent.com/u/81921591	20163966	xe	ờ	đạp	Hóa gì năm làm bàn bơi gió máy tủ. Thương mười phá chỉ thế cái viết làm mây. Nhà yêu việc là chín em một xanh bàn.	0	2023-12-09 01:07:49.835944	2023-12-09 01:07:49.835944
69	Linh Lan Tô	nGscKseJRNQh20N	HieuVan61@hotmail.com	13	0	2023-07-16 10:38:19	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/913.jpg	20154787	là	lỗi	là	Trời xanh tôi nón quần. Tô nha giày đạp bảy leo. Áo mây khoảng dép thích máy kim anh trời vá.	1	2023-12-09 01:07:49.838121	2023-12-09 01:07:49.838121
70	Minh Khôi Tô	UNDgYJGduz1tGPM	GiaLinh15@yahoo.com	15	0	2023-06-17 08:17:31	https://avatars.githubusercontent.com/u/52002406	20223319	tô	năm	một	Thế khoan leo xe chỉ đang làm mười tàu khoan. Mười lầu bàn ba thế bốn lỗi quê lầu tô. Mười cái vẽ bốn thương biển ngọt năm chín.	0	2023-12-09 01:07:49.840207	2023-12-09 01:07:49.840207
71	Thanh Vũ Hoàng	NuCz0ASvGDGdjjh	DieuAnh.To68@yahoo.com	29	0	2023-03-24 08:50:15	https://avatars.githubusercontent.com/u/19788377	20141988	máy	biết	là	Biển sáu mướn hàng thuê gì ờ tô. Chìm ba chỉ ác thuê hết khâu may ghét tui. Nón mây đâu.	1	2023-12-09 01:07:49.842321	2023-12-09 01:07:49.842321
72	Hồng Điệp Đinh	TquL91dCXiOWbKi	Bich7kao_Duong45@yahoo.com	89	1	2023-06-29 05:28:21	https://avatars.githubusercontent.com/u/19028865	20148729	hết	vá	bơi	Nhà chìm hai leo. Ba đồng anh ghế một bảy bảy quê thế máy. Ghét bảy giày hóa vẽ khâu ờ.	1	2023-12-09 01:07:49.844387	2023-12-09 01:07:49.844387
73	Lệ Quân Dương	izPqIpHRHQvy9BW	NgocLe_Truong62@yahoo.com	23	0	2023-11-06 10:08:47	https://avatars.githubusercontent.com/u/57250503	20149235	thích	vá	phá	Xuồng cái mười núi nón bốn giày. Máy cái leo đá đạp ngọt tủ leo xe. Yêu bơi đồng ghế nón gió nhà lỗi tám.	0	2023-12-09 01:07:49.846503	2023-12-09 01:07:49.846503
74	Hữu Trác Đinh	S6B0PtWGY0wxFEp	ThaoNguyen_7kinh4@gmail.com	97	0	2023-05-18 02:29:15	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/708.jpg	20223039	bạn	may	cái	Khoan hương chín đạp mượn đồng đồng. Hết áo đạp quê trăng. Không lầu nón mây dép quần.	0	2023-12-09 01:07:49.848505	2023-12-09 01:07:49.848505
75	Linh Nhi Trương	YatveYj81rQqFCj	ThienTinh94@gmail.com	92	0	2023-05-04 22:40:47	https://avatars.githubusercontent.com/u/43149951	20221431	không	được	hương	Chết tám đỏ đập. Tui gió anh bảy chết tui không. Sáu nha lầu em thuyền viết nhà ruộng.	0	2023-12-09 01:07:49.850849	2023-12-09 01:07:49.850849
76	Hồng Lân Trương	kUYMqXYti7Z6iE_	ThanhTam.Ha@yahoo.com	1	1	2023-05-25 21:32:29	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/173.jpg	20168420	đánh	là	làm	Đang trời bàn. Khâu yêu giết độc sáu. Đánh khoan vàng em đã biết mướn mua.	0	2023-12-09 01:07:49.853063	2023-12-09 01:07:49.853063
77	Trúc Đào Lý	cQskSrbOBoZAxC9	GiaoKieu10@hotmail.com	74	1	2022-12-16 21:38:06	https://avatars.githubusercontent.com/u/80409475	20164195	gì	ruộng	ghét	Khâu vá biết ghế bơi ừ nón phá thì. Hàng trăng nước thế lỗi hai. Cửa đánh thuê á.	0	2023-12-09 01:07:49.855256	2023-12-09 01:07:49.855256
78	Hoàng Linh Bùi	b5Iws6UNe0drLdP	SonGiang52@gmail.com	61	1	2023-01-29 03:43:51	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/246.jpg	20207446	đang	dép	vẽ	Vá thôi giết biết không. Mướn lỗi hóa hai thương tím hết độc lầu hàng. Bảy thương đang đánh em được đã.	1	2023-12-09 01:07:49.857304	2023-12-09 01:07:49.857304
79	Trúc Lan Hồ	SH5eiEeHeguqfwi	PhuongDiem62@gmail.com	18	0	2023-04-13 13:47:35	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/574.jpg	20147581	sáu	lỗi	hương	Cửa mua nghỉ quần. Hóa trời tàu là nha. Xe đỏ anh cửa tàu đâu nha.	0	2023-12-09 01:07:49.860005	2023-12-09 01:07:49.860005
80	Trung Nghĩa Đặng	m8FRAh2w3cn4ALZ	BachTuyet.Hoang76@yahoo.com	57	1	2023-03-28 18:08:41	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/523.jpg	20204467	khoảng	khoảng	ừ	Quần dép đỏ nước mướn bè hóa. Bảy cửa khoan. Anh quê tàu ác ác cửa mướn.	1	2023-12-09 01:07:49.862216	2023-12-09 01:07:49.862216
81	Quốc Thành Nguyễn	2WYr26ofHY8ZSMo	ManhTruong.Ha9@gmail.com	64	0	2023-03-02 23:22:07	https://avatars.githubusercontent.com/u/78874397	20224653	thuyền	nón	bè	Quê anh giày năm đỏ. Áo nghỉ nón á phá viết. Ghét vẽ vẽ chỉ.	0	2023-12-09 01:07:49.864656	2023-12-09 01:07:49.864656
82	Thụy Trinh Ngô	rBlmz3L1vSxeMu6	NhuTam89@hotmail.com	26	0	2023-09-07 10:32:16	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/428.jpg	20180445	bè	con	chết	Cái nghỉ hóa đâu một nha tôi ruộng giày. Nón chìm lầu việc ba máy đang giày. Đã giày leo đã bơi nghỉ nhà nha.	0	2023-12-09 01:07:49.866908	2023-12-09 01:07:49.866908
83	Ngọc Đào Đỗ	UHRXwFb3uQEhhdz	Hai7kuong_Vuong@hotmail.com	21	0	2022-12-15 11:15:45	https://avatars.githubusercontent.com/u/10003641	20208168	sáu	hóa	thương	Thôi không á hai bơi dép chỉ thuê. Ghét á bốn phá ác bạn em. Ghế bè nha tôi là.	1	2023-12-09 01:07:49.869039	2023-12-09 01:07:49.869039
84	Thông Minh Vương	nHSvKnu92F6aA10	ThuongHuyen.Le23@yahoo.com	25	0	2023-01-10 13:17:20	https://avatars.githubusercontent.com/u/11161640	20208833	lầu	thuê	giày	Đã đánh mười lầu. Vẽ may ừ mượn ác ác phá tôi được. Hương viết thôi ác bàn xe tôi ruộng đạp.	1	2023-12-09 01:07:49.871039	2023-12-09 01:07:49.871039
85	Thu Huệ Phan	I9mI4CLJjLE_spl	CongLy4@gmail.com	30	1	2023-04-22 13:44:43	https://avatars.githubusercontent.com/u/43934207	20234195	đâu	bạn	đỏ	Máy thế khoảng không mượn hóa nước ghế gì đỏ. Gió sáu ba khâu tủ dép lỗi. Biết xanh bốn khâu áo bè năm.	0	2023-12-09 01:07:49.873065	2023-12-09 01:07:49.873065
86	Trọng Trí Phạm	2Ow6Y844vUTNrKD	MinhNhan.Ngo39@yahoo.com	91	1	2023-09-08 20:01:22	https://avatars.githubusercontent.com/u/93512830	20193806	may	bơi	anh	Hóa lỗi xuồng hàng ba ác bàn. Là trăng vàng vàng ghét tôi viết ghế. Năm tàu em thương quần ác áo đạp.	0	2023-12-09 01:07:49.875014	2023-12-09 01:07:49.875014
87	Quốc Hiển Mai	GhEoVt86RJEI7CE	MinhYen89@gmail.com	45	0	2023-10-31 16:37:50	https://avatars.githubusercontent.com/u/3748247	20222971	được	gì	bảy	Bảy đã quần trời. Là ruộng đá đang vẽ dép. Chín bảy thế tô.	1	2023-12-09 01:07:49.877108	2023-12-09 01:07:49.877108
88	Tuấn Tú Đỗ	Fdbh1UYRgk3G7_2	HoangLong_Ngo54@yahoo.com	76	1	2023-03-21 03:34:36	https://avatars.githubusercontent.com/u/86553096	20162571	xanh	mua	mượn	Tô đá đá phá nước đã. Kim bảy vẽ trăng thích tô được. Biển quê ác.	0	2023-12-09 01:07:49.879213	2023-12-09 01:07:49.879213
89	Xuân Trường Hồ	MrHBgduggTKbQ4O	ChiDung_Phung89@yahoo.com	7	0	2023-02-21 07:57:31	https://avatars.githubusercontent.com/u/46571361	20177544	tôi	thuyền	giết	Năm thì cửa hương áo. Nhà mây khoảng. Thương bốn xanh.	1	2023-12-09 01:07:49.881315	2023-12-09 01:07:49.881315
90	Trọng Vinh Tô	2TdepJ3a8F9qhm5	PhuongLien94@gmail.com	62	1	2023-07-11 15:51:55	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/236.jpg	20185399	khoảng	xanh	máy	Xe sáu khoan ừ gió tủ xe. Ba việc anh kim. Ngọt vẽ bốn tui thì gió việc núi.	1	2023-12-09 01:07:49.883398	2023-12-09 01:07:49.883398
91	Hoàng Hiệp Bùi	UAXS7Ed4Cu7_4yT	MaiHuong_Pham38@yahoo.com	8	1	2023-06-14 21:44:18	https://avatars.githubusercontent.com/u/23760166	20228443	nghỉ	khâu	nghỉ	Ừ leo tôi hóa biển bốn được. Chìm đã quần tám ừ đánh. Thương vẽ á.	0	2023-12-09 01:07:49.885297	2023-12-09 01:07:49.885297
92	Trà Giang Phạm	jS7Nd_kclN4iYa0	XuanBao_Phung19@yahoo.com	40	0	2023-04-03 09:51:11	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/1029.jpg	20226894	lầu	xe	tôi	Ờ viết mười gió bảy á mua ghế làm hết. Cái hai hương bốn giày á. Dép ghét đang.	0	2023-12-09 01:07:49.88741	2023-12-09 01:07:49.88741
94	Tường Phát Nguyễn	Aztuk0P6C76alZY	VanChi_Truong@yahoo.com	6	0	2023-04-01 15:35:21	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/704.jpg	20180937	nha	nha	đồng	Lầu thuyền mua bè. Vẽ xe biển ờ khoan. Chỉ làm hai.	0	2023-12-09 01:07:49.891728	2023-12-09 01:07:49.891728
95	Đan Tâm Đào	mAPgMvuAJEiIDK_	SonGiang_Ly58@gmail.com	45	0	2023-11-09 22:51:02	https://avatars.githubusercontent.com/u/70697606	20187660	đập	nghỉ	được	Tàu sáu khâu ừ viết đạp. Tui lầu đỏ xanh mười nón giết đâu thương. Mây bè thương đá anh phá bơi.	1	2023-12-09 01:07:49.893826	2023-12-09 01:07:49.893826
96	Bảo Long Đỗ	SrVA7c3PypQoi3F	NgocAi0@gmail.com	31	1	2023-08-20 07:48:51	https://avatars.githubusercontent.com/u/9625877	20159675	đâu	yêu	ghế	Nước đỏ á vẽ tui việc. Khoảng núi mượn làm quê mua cái thôi đâu chỉ. Cái anh mua hương leo hương.	0	2023-12-09 01:07:49.895807	2023-12-09 01:07:49.895807
97	Khả Ái Phan	gEW84xuaXCB9QLE	HoaiPhuong_Tang@gmail.com	1	1	2023-07-03 04:47:44	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/1119.jpg	20184231	bơi	nhà	xanh	Mười được bốn may á. Tàu vẽ được biết biển đập khoảng bốn may. Không khoảng chỉ leo gì kim.	1	2023-12-09 01:07:49.897636	2023-12-09 01:07:49.897636
98	Vy Lan Phùng	NQLn_hjPRgWzNqG	AnNhien.Ly78@gmail.com	22	0	2023-07-07 14:09:11	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/413.jpg	20225620	tôi	cửa	khâu	Lỗi giày là xuồng chín ghế. Đạp đỏ dép. Đã thương dép quê nghỉ giày ghét nón nước.	0	2023-12-09 01:07:49.899709	2023-12-09 01:07:49.899709
99	Mạnh Tuấn Đặng	1cmF6xclk4MiPYq	PhuocLoc_Pham@yahoo.com	30	1	2023-12-08 13:39:42	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/762.jpg	20167169	may	áo	đá	Giày anh tám hóa mười ruộng một ờ trời. Không đang vá bàn ba đang tô. Biết ờ thương đạp xuồng đá tô.	0	2023-12-09 01:07:49.902137	2023-12-09 01:07:49.902137
100	Họa Mi Hoàng	yGmcpieQCvWYXAi	ThuNga.Ho8@hotmail.com	84	1	2023-08-07 16:30:02	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/683.jpg	20141910	ba	tàu	nhà	Mua lỗi anh. Mướn hương cửa tủ. Thôi đâu mượn á hàng mua.	1	2023-12-09 01:07:49.904194	2023-12-09 01:07:49.904194
\.


--
-- Name: answer_likes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.answer_likes_id_seq', 1, false);


--
-- Name: answer_notifications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.answer_notifications_id_seq', 1, false);


--
-- Name: answers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.answers_id_seq', 100, true);


--
-- Name: question_likes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.question_likes_id_seq', 1, false);


--
-- Name: question_notifications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.question_notifications_id_seq', 1, false);


--
-- Name: question_tag_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.question_tag_id_seq', 1, false);


--
-- Name: questions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.questions_id_seq', 100, true);


--
-- Name: tags_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tags_id_seq', 100, true);


--
-- Name: user_tokens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_tokens_id_seq', 1, false);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 100, true);


--
-- Name: answer_likes answer_likes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.answer_likes
    ADD CONSTRAINT answer_likes_pkey PRIMARY KEY (id);


--
-- Name: answer_notifications answer_notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.answer_notifications
    ADD CONSTRAINT answer_notifications_pkey PRIMARY KEY (id);


--
-- Name: answers answers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.answers
    ADD CONSTRAINT answers_pkey PRIMARY KEY (id);


--
-- Name: question_likes question_likes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.question_likes
    ADD CONSTRAINT question_likes_pkey PRIMARY KEY (id);


--
-- Name: question_notifications question_notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.question_notifications
    ADD CONSTRAINT question_notifications_pkey PRIMARY KEY (id);


--
-- Name: question_tag question_tag_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.question_tag
    ADD CONSTRAINT question_tag_pkey PRIMARY KEY (id);


--
-- Name: questions questions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.questions
    ADD CONSTRAINT questions_pkey PRIMARY KEY (id);


--
-- Name: tags tags_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: user_tokens user_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_tokens
    ADD CONSTRAINT user_tokens_pkey PRIMARY KEY (id);


--
-- Name: user_tokens user_tokens_user_id_token_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_tokens
    ADD CONSTRAINT user_tokens_user_id_token_key UNIQUE (user_id, token);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: answer_likes answer_like_count_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER answer_like_count_trigger AFTER INSERT OR DELETE ON public.answer_likes FOR EACH ROW EXECUTE FUNCTION public.update_answer_like_count();


--
-- Name: question_likes question_like_count_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER question_like_count_trigger AFTER INSERT OR DELETE ON public.question_likes FOR EACH ROW EXECUTE FUNCTION public.update_question_like_count();


--
-- Name: answers set_timestamp; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_timestamp BEFORE UPDATE ON public.answers FOR EACH ROW EXECUTE FUNCTION public.trigger_set_timestamp();


--
-- Name: questions set_timestamp; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_timestamp BEFORE UPDATE ON public.questions FOR EACH ROW EXECUTE FUNCTION public.trigger_set_timestamp();


--
-- Name: users set_timestamp; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_timestamp BEFORE UPDATE ON public.users FOR EACH ROW EXECUTE FUNCTION public.trigger_set_timestamp();


--
-- Name: answer_likes answer_likes_answerid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.answer_likes
    ADD CONSTRAINT answer_likes_answerid_fkey FOREIGN KEY (answerid) REFERENCES public.answers(id);


--
-- Name: answer_likes answer_likes_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.answer_likes
    ADD CONSTRAINT answer_likes_userid_fkey FOREIGN KEY (userid) REFERENCES public.users(id);


--
-- Name: answer_notifications answer_notifications_answerid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.answer_notifications
    ADD CONSTRAINT answer_notifications_answerid_fkey FOREIGN KEY (answerid) REFERENCES public.answers(id);


--
-- Name: answer_notifications answer_notifications_recipientid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.answer_notifications
    ADD CONSTRAINT answer_notifications_recipientid_fkey FOREIGN KEY (recipientid) REFERENCES public.users(id);


--
-- Name: answer_notifications answer_notifications_senderid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.answer_notifications
    ADD CONSTRAINT answer_notifications_senderid_fkey FOREIGN KEY (senderid) REFERENCES public.users(id);


--
-- Name: answers answers_questionid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.answers
    ADD CONSTRAINT answers_questionid_fkey FOREIGN KEY (questionid) REFERENCES public.questions(id);


--
-- Name: answers answers_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.answers
    ADD CONSTRAINT answers_userid_fkey FOREIGN KEY (userid) REFERENCES public.users(id);


--
-- Name: question_likes question_likes_questionid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.question_likes
    ADD CONSTRAINT question_likes_questionid_fkey FOREIGN KEY (questionid) REFERENCES public.questions(id);


--
-- Name: question_likes question_likes_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.question_likes
    ADD CONSTRAINT question_likes_userid_fkey FOREIGN KEY (userid) REFERENCES public.users(id);


--
-- Name: question_notifications question_notifications_questionid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.question_notifications
    ADD CONSTRAINT question_notifications_questionid_fkey FOREIGN KEY (questionid) REFERENCES public.questions(id);


--
-- Name: question_notifications question_notifications_recipientid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.question_notifications
    ADD CONSTRAINT question_notifications_recipientid_fkey FOREIGN KEY (recipientid) REFERENCES public.users(id);


--
-- Name: question_notifications question_notifications_senderid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.question_notifications
    ADD CONSTRAINT question_notifications_senderid_fkey FOREIGN KEY (senderid) REFERENCES public.users(id);


--
-- Name: question_tag question_tag_questionid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.question_tag
    ADD CONSTRAINT question_tag_questionid_fkey FOREIGN KEY (questionid) REFERENCES public.questions(id);


--
-- Name: question_tag question_tag_tagid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.question_tag
    ADD CONSTRAINT question_tag_tagid_fkey FOREIGN KEY (tagid) REFERENCES public.tags(id);


--
-- Name: questions questions_answers_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.questions
    ADD CONSTRAINT questions_answers_id_fk FOREIGN KEY (acceptedanswerid) REFERENCES public.answers(id);


--
-- Name: questions questions_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.questions
    ADD CONSTRAINT questions_userid_fkey FOREIGN KEY (userid) REFERENCES public.users(id);


--
-- Name: user_tokens user_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_tokens
    ADD CONSTRAINT user_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- PostgreSQL database dump complete
--

--
-- Database "postgres" dump
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 15.5
-- Dumped by pg_dump version 15.5

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

DROP DATABASE postgres;
--
-- Name: postgres; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE postgres WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.utf8';


ALTER DATABASE postgres OWNER TO postgres;

\connect postgres

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

--
-- Name: DATABASE postgres; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON DATABASE postgres IS 'default administrative connection database';


--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database cluster dump complete
--

