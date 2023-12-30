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

CREATE OR REPLACE FUNCTION public.update_answer_like_count() RETURNS trigger
    LANGUAGE plpgsql
    AS $$



BEGIN



    IF TG_OP = 'INSERT' THEN
        -- Update likecount when a new row is inserted
        UPDATE answers
        SET likecount = (SELECT COALESCE(COUNT(*), 0) FROM answer_likes WHERE answer_likes.answerId = NEW.answerId)
        WHERE answers.id = NEW.answerId;
    ELSIF TG_OP = 'DELETE' THEN
        -- Update likecount when a row is deleted
        UPDATE answers
        SET likecount = (SELECT COALESCE(COUNT(*), 0) FROM answer_likes WHERE answer_likes.answerId = OLD.answerId)
        WHERE answers.id = OLD.answerId;
    END IF;



    RETURN NEW;



END;



$$;


ALTER FUNCTION public.update_answer_like_count() OWNER TO postgres;

--
-- Name: update_question_like_count(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE OR REPLACE FUNCTION public.update_question_like_count() RETURNS trigger
    LANGUAGE plpgsql
    AS $$



BEGIN



    IF TG_OP = 'INSERT' THEN
        -- Update likecount when a new row is inserted
        UPDATE questions
        SET likecount = (SELECT COALESCE(COUNT(*), 0) FROM question_likes WHERE question_likes.questionId = NEW.questionId)
        WHERE questions.id = NEW.questionId;
    ELSIF TG_OP = 'DELETE' THEN
        -- Update likecount when a row is deleted
        UPDATE questions
        SET likecount = (SELECT COALESCE(COUNT(*), 0) FROM question_likes WHERE question_likes.questionId = OLD.questionId)
        WHERE questions.id = OLD.questionId;
    END IF;


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

-- Thêm cột unreadcount vào bảng users và đặt giá trị mặc định là 0
ALTER TABLE public.users
ADD COLUMN unreadcount integer DEFAULT 0;

-- Tạo hoặc cập nhật hàm trigger update_unread_count
CREATE OR REPLACE FUNCTION public.update_unread_count()
RETURNS TRIGGER AS $$
BEGIN
    -- Kiểm tra nếu là thao tác UPDATE
    IF TG_OP = 'UPDATE' THEN
        -- Kiểm tra xem giá trị hasread có thay đổi không
        IF OLD.hasread <> NEW.hasread THEN
            -- Cập nhật unreadcount dựa trên question_notifications và answer_notifications
            UPDATE public.users
            SET unreadcount = (
                SELECT COUNT(*)
                FROM public.question_notifications
                WHERE recipientid = NEW.recipientid AND hasread = 0
            ) + (
                SELECT COUNT(*)
                FROM public.answer_notifications
                WHERE recipientid = NEW.recipientid AND hasread = 0
            )
            WHERE id = NEW.recipientid;
        END IF;
    ELSE
        -- Xử lý cho các trường hợp INSERT hoặc DELETE
        -- Cập nhật unreadcount dựa trên question_notifications và answer_notifications
        UPDATE public.users
        SET unreadcount = (
            SELECT COUNT(*)
            FROM public.question_notifications
            WHERE recipientid = NEW.recipientid AND hasread = 0
        ) + (
            SELECT COUNT(*)
            FROM public.answer_notifications
            WHERE recipientid = NEW.recipientid AND hasread = 0
        )
        WHERE id = NEW.recipientid;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Tạo hoặc cập nhật trigger tr_update_unread_count
CREATE TRIGGER tr_update_unread_count
AFTER INSERT OR UPDATE OR DELETE ON public.question_notifications
    FOR EACH ROW EXECUTE FUNCTION public.update_unread_count();

-- Tạo hoặc cập nhật trigger tr_update_unread_count_answer
CREATE TRIGGER tr_update_unread_count_answer
AFTER INSERT OR UPDATE OR DELETE ON public.answer_notifications
    FOR EACH ROW EXECUTE FUNCTION public.update_unread_count();
    
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
1	Giết giày chỉ ờ đồng thích bốn phá. Khoan áo cái mười. Mây con đá cửa tím cửa quê.	1	0	52	15	2023-01-26 21:22:04	2023-12-09 12:53:08.511991
2	Xanh một ghế. Em núi chìm. Thuyền hóa biết thôi.	1	0	56	75	2023-01-01 03:20:34	2023-12-09 12:53:08.51332
3	Quần đang gì. Độc thì không. Thế tàu trăng sáu tô chỉ thì anh áo thôi.	1	0	81	37	2023-11-30 01:58:31	2023-12-09 12:53:08.51438
4	Việc hai chìm bè. Bè á phá làm giết khoan. Ừ gió anh.	1	0	51	37	2023-11-27 11:38:27	2023-12-09 12:53:08.515332
6	Nón sáu tím chìm hàng năm gió bàn nhà đã. Tủ chết dép phá thì bè. Nón bè ba độc leo mười nha chín thuyền thích.	1	0	13	4	2023-07-09 23:59:44	2023-12-09 12:53:08.517445
7	Á kim núi. Bốn năm ác gì xe đạp núi gì nha. Con tôi thôi leo.	0	0	98	57	2023-05-05 14:13:18	2023-12-09 12:53:08.51841
8	Việc đập bè tôi. Hàng tàu giết chết đâu em đồng. Độc may lầu vàng leo ruộng trời không bốn.	0	0	7	56	2023-09-05 07:16:33	2023-12-09 12:53:08.519388
9	Đánh á nón nghỉ tô núi tui áo. Ruộng dép núi mượn trời mướn leo. Hết nước đạp máy viết.	0	0	1	43	2023-04-14 03:36:07	2023-12-09 12:53:08.520347
10	Tám ghế nhà sáu bốn nước đá con dép. Bơi đá trăng đã núi. Độc chết xuồng tui bảy tui.	1	0	80	22	2023-12-07 12:49:58	2023-12-09 12:53:08.521352
11	Chìm khoảng trời đang quê ngọt đạp. Mười ác lầu hương tui em thương. Trăng mây thích ờ.	0	0	4	19	2023-03-05 16:58:52	2023-12-09 12:53:08.522291
12	Quê hương sáu không biển năm. Ghế ruộng kim. Nón ba máy bè đỏ mướn cửa chỉ ba tám.	0	0	53	16	2023-11-17 21:53:20	2023-12-09 12:53:08.523247
13	Mây mười bạn giết tàu vàng nghỉ dép. Ruộng năm ba nha cái tám thuyền. Đã thì tôi leo áo xuồng trăng dép leo.	0	0	65	18	2023-10-24 16:17:25	2023-12-09 12:53:08.524197
14	Việc nhà lầu chín thích kim sáu ghế làm. Biển giày bốn hết thuyền biết tám. Hương ruộng may đánh giết đá năm áo chín.	0	0	66	1	2023-09-28 19:10:08	2023-12-09 12:53:08.525112
15	Giết ừ ba ghế quê tàu là ác hàng biển. Trời tui hương năm. Nha núi nha bơi giết con leo đâu hương.	0	0	67	20	2023-03-29 05:52:22	2023-12-09 12:53:08.526454
16	Bơi tôi tủ bốn là cửa khoan năm đá. Con bơi lỗi máy nghỉ vá anh đã. Đá thuê tôi tàu thích đạp biển.	0	0	43	9	2023-09-02 02:50:07	2023-12-09 12:53:08.527632
17	Thôi giày làm tàu khoảng bơi trời em máy. Chết thương hết. Anh thuyền thuyền lầu.	1	0	2	71	2023-06-30 13:03:17	2023-12-09 12:53:08.528662
18	Thích lỗi đâu ruộng thương vá xanh gì. Việc tô lỗi ờ quê ghét leo nghỉ ác. Ba cái may không nước ruộng tủ không đạp.	1	0	45	46	2023-06-12 18:03:59	2023-12-09 12:53:08.529745
19	Xanh tủ tô bạn bàn đồng chín đánh nón. Phá đập hai thuê mua con nghỉ mười đánh. Vẽ khoan vàng quê ừ nước sáu thuê.	1	0	58	4	2023-05-31 04:18:12	2023-12-09 12:53:08.530898
20	Kim sáu trời mây đâu là bốn hết. Ác biển mượn lỗi chỉ tím mua tô trăng lỗi. Hai ác đâu mây.	1	0	37	15	2023-06-13 05:47:17	2023-12-09 12:53:08.532044
21	Gió chìm mây mười quê vá đập khâu tàu. Gì máy nón việc mây. Ba ghét bàn ghét.	0	0	93	59	2023-03-19 06:41:27	2023-12-09 12:53:08.533036
22	Yêu giày thế máy tám đã chỉ tủ tám mượn. Vá anh trăng. Tám nha viết mười máy tô ừ kim hai biết.	1	0	63	43	2023-10-19 15:48:06	2023-12-09 12:53:08.534064
23	Nước làm ờ mây chìm tím. Sáu quê em trăng không leo trời đồng thế ba. Hai mười tám nghỉ hương tôi chín đập.	0	0	92	71	2023-01-03 02:11:20	2023-12-09 12:53:08.535101
24	Biển lỗi hàng đồng viết thuyền bàn cái. Hai đạp tím. Là hóa cái.	0	0	47	84	2023-09-08 06:33:45	2023-12-09 12:53:08.536079
25	Thuyền hết là gì sáu chết. Mua thương được đá nghỉ thuê. Hóa xanh áo biết quần đỏ chìm ba núi cái.	1	0	56	53	2022-12-26 20:03:32	2023-12-09 12:53:08.537103
26	Ờ thích tô một tàu đỏ sáu hai mây. Bốn hàng xanh núi. Không ác ghét chín.	0	0	19	86	2023-02-05 23:14:12	2023-12-09 12:53:08.538067
27	Tám mướn hết xe. Ghét thuê thuê xe leo thì hóa em. Con chín thương tím mướn bốn giày.	0	0	36	63	2023-07-14 19:05:32	2023-12-09 12:53:08.539029
28	Phá khâu đỏ đang làm. Thích bơi đâu mây. Leo lỗi biển trời ờ xanh.	1	0	44	19	2023-06-18 18:37:13	2023-12-09 12:53:08.540064
29	Ác độc xuồng vàng giày giết tàu gió. Hương may là ờ đang độc biển. Tủ gì ghét.	0	0	61	6	2023-02-07 13:35:18	2023-12-09 12:53:08.541023
30	Ngọt gió dép áo một ờ sáu ba được. Biển bàn chỉ sáu phá mười bảy tủ thôi. Chết đã hóa bạn tám bảy đạp xuồng xanh nước.	0	0	24	72	2023-12-07 14:52:02	2023-12-09 12:53:08.542017
31	May chết mây tám kim quê lầu giày. Đạp mười tôi trời chết độc. Ruộng bạn tôi khâu yêu tô kim.	1	0	22	83	2023-03-22 20:00:51	2023-12-09 12:53:08.542967
32	Lầu con mười. Tủ tím biển. Nha gì áo ghế đá biển.	0	0	42	10	2023-04-17 13:59:54	2023-12-09 12:53:08.544015
33	Hàng thương hóa khoan xe thuê bàn yêu độc bơi. Thuyền chết xuồng khoan thuyền mười thuyền lỗi cái. Yêu đá trăng anh đỏ nghỉ.	0	0	22	31	2023-09-24 13:33:56	2023-12-09 12:53:08.545012
34	Cái việc hàng. Giết một khoan lầu độc đập hàng. Mua tám phá chín đồng phá được hai con.	0	0	55	70	2023-03-10 10:05:31	2023-12-09 12:53:08.545935
35	Máy bảy giết hàng. Mướn khoan thì mượn việc nón. Tàu thế làm áo máy khâu.	1	0	53	14	2022-12-17 20:48:29	2023-12-09 12:53:08.546884
36	Bơi giày em khoan hai con tàu. Con hóa em khoan may trời hết ngọt cái. Mây thích thôi thế núi anh leo.	0	0	40	85	2023-01-25 20:53:22	2023-12-09 12:53:08.547846
37	Đá núi tôi chỉ một việc làm biết giết đâu. Máy nha tui bốn xanh sáu thương. Năm hương kim gì giết trời biển được đạp thuê.	1	0	62	15	2023-06-18 08:57:54	2023-12-09 12:53:08.548787
38	Bè giết đỏ giày biết. Ghế núi vá đá dép. Mười anh cửa.	1	0	11	29	2023-04-29 09:15:05	2023-12-09 12:53:08.549698
39	Thuyền quần hóa quần bạn yêu đang biết nhà kim. Quần hai gió đang nha viết hương đã đá hai. Nước thích bốn phá phá thích kim.	0	0	43	96	2023-04-22 12:47:10	2023-12-09 12:53:08.550887
40	Thì được sáu đánh ừ đâu nghỉ. Hai vàng em kim một trăng ừ thương. Phá làm bàn tô không ruộng khâu leo tui làm.	1	0	10	40	2023-06-02 06:49:59	2023-12-09 12:53:08.55185
41	Năm nước yêu trăng mây quần xanh đang giết bốn. Vá trăng thuê máy cửa cửa tô tôi tàu. Làm vàng được thôi hết leo mượn.	0	0	77	85	2023-10-02 21:23:32	2023-12-09 12:53:08.552805
42	Đá là gì ngọt biển lầu ghét ruộng. Xuồng vẽ hết biết. Khâu mượn giày hết con nha gió.	1	0	33	11	2023-10-27 07:21:14	2023-12-09 12:53:08.553715
43	Việc đánh viết. Quê tủ cái ba. Viết bốn đập biết.	1	0	7	18	2023-03-11 16:49:39	2023-12-09 12:53:08.554627
44	Khâu là tím nước mây mua hàng. Sáu lầu đập đạp leo. Đã khoan đập tàu chín ừ em nghỉ nghỉ đánh.	1	0	91	95	2023-10-07 11:16:29	2023-12-09 12:53:08.555657
45	Một thôi hóa bàn quần mượn. Xuồng đồng máy ác tui nón đã nón đang bè. Quần bạn mướn đã.	1	0	12	6	2023-03-30 19:39:28	2023-12-09 12:53:08.556636
46	Gì vẽ bè nhà năm núi ờ hương hết hóa. Đập đập quê chỉ bè thương xe. Bè mượn sáu bơi mướn ờ.	1	0	65	76	2023-06-01 10:30:27	2023-12-09 12:53:08.557782
48	Bè thuê em xuồng núi chết. Nón thì quần năm đồng khâu giết. Mây được thích vàng chín không bảy xuồng bơi.	0	0	39	22	2023-04-04 05:44:08	2023-12-09 12:53:08.559762
49	Đánh tím thuê chín leo. Đạp ngọt bơi bạn việc ờ trăng tím hàng. Áo khâu bơi đâu mười thế ừ.	1	0	71	11	2023-09-22 02:42:36	2023-12-09 12:53:08.560722
50	Hết núi gì mượn. Một không hai hết á ghế. Đã khâu ghế nhà tám tủ tôi.	1	0	51	34	2023-11-20 18:50:47	2023-12-09 12:53:08.561686
51	Tôi hàng thuyền may khoảng tô em. Gì viết hết một áo bàn xuồng. Tôi ác thôi nghỉ đồng nước chìm.	0	0	91	40	2023-04-26 02:57:55	2023-12-09 12:53:08.562671
52	Ghế vẽ tàu trăng đâu việc thôi mười. Phá trăng ghét đã dép quần. Mây thế quê tui khâu trời mượn khâu ờ mây.	1	0	95	53	2023-03-22 22:52:55	2023-12-09 12:53:08.563673
53	Đồng năm bè. Tám ghế tủ tui thôi tui đánh áo. Ờ mười núi máy thôi mười.	1	0	20	78	2023-07-28 21:07:18	2023-12-09 12:53:08.564726
54	Ghét ghét đỏ hai á trăng mướn. Thế đang ờ xanh bốn ừ xuồng đập yêu dép. Sáu đồng nước ghế đã vàng tô vàng tím con.	0	0	88	77	2023-05-22 09:15:41	2023-12-09 12:53:08.565704
55	Tám nhà đỏ hai leo ghét một thuyền biết tím. Đang bạn gì vàng tô đâu may giày khâu độc. Yêu đạp lầu.	0	0	63	32	2023-11-29 04:33:37	2023-12-09 12:53:08.566691
56	Leo hương làm sáu tui thì bạn. Đánh vá nha mướn. Đồng máy tui thuê.	1	0	38	60	2023-11-21 21:13:56	2023-12-09 12:53:08.567667
57	Việc khoan xe nón đồng đâu độc đánh. Ác máy độc giày dép vàng viết hàng xuồng. Nha áo hàng chìm nghỉ khoảng một bốn ừ.	0	0	86	87	2023-02-01 11:18:40	2023-12-09 12:53:08.568618
58	Sáu thuyền xuồng xanh một hương nhà á vá. Cửa tôi con quần. Làm chết lầu đang thích tám mướn hàng.	1	0	9	36	2023-06-25 20:03:27	2023-12-09 12:53:08.569548
59	Thích quần em ngọt tím chín. Dép thế mười đâu hóa đồng. Sáu không dép.	0	0	77	15	2023-01-24 22:58:05	2023-12-09 12:53:08.570483
60	Ghét quê trăng đỏ. Bảy tui ghét. Tám độc ghế ngọt leo thì may gió á.	0	0	99	56	2023-12-01 21:09:28	2023-12-09 12:53:08.571422
61	Ác giày áo. Lỗi hết ừ mây ác. Xuồng chín phá áo tàu khoảng vá nhà tàu khoảng.	1	0	8	7	2023-08-04 12:19:04	2023-12-09 12:53:08.572387
62	Ờ máy tôi ngọt tôi núi không. Thương gió chết kim bảy hai quần. Mua mười tôi lầu leo yêu.	0	0	72	88	2023-08-16 01:25:16	2023-12-09 12:53:08.573399
63	Tô khoảng việc. Giày viết thương nước tám may chín vẽ tủ. Kim thương vẽ thương chín hương vàng được.	0	0	75	30	2023-06-16 22:13:24	2023-12-09 12:53:08.574379
64	Trời quê tô đang nhà thương quần mướn. Giày áo á đã nha vá thương năm dép. Tám ác hết xuồng đỏ thì mua đâu.	0	0	70	56	2023-06-09 23:31:54	2023-12-09 12:53:08.575398
65	Biển dép con cửa xe xe là hai đập không. Đánh may độc vá xanh bảy ba tím. Cái năm ác.	1	0	68	72	2022-12-21 16:50:53	2023-12-09 12:53:08.576506
66	Chín bơi áo yêu ghét. Đang mây nước gì trời leo là ghế. Gì cửa ba nha nhà thế.	1	0	2	43	2023-04-26 07:51:03	2023-12-09 12:53:08.577468
67	Làm bơi ba được. Giết chỉ tím. Mướn ừ hóa xanh giày khâu hóa ba độc ghét.	1	0	12	80	2023-07-15 05:12:38	2023-12-09 12:53:08.578427
68	Ngọt á tôi thuê leo ghét tôi bơi đánh. Khoan nghỉ đá bạn quần cửa trăng ruộng khâu cửa. Là bảy ruộng chỉ không.	0	0	70	53	2023-09-12 16:49:51	2023-12-09 12:53:08.579409
69	Viết trăng xe nghỉ. Cửa thế gió độc núi áo mua. Tàu hết biết chết kim không.	0	0	91	52	2023-03-17 09:22:03	2023-12-09 12:53:08.580363
70	Bè mượn mướn quê thương bơi. Được lầu việc bốn đang tui xe bảy tôi á. Khoảng trời nhà trăng tủ.	0	0	44	37	2023-10-31 22:47:52	2023-12-09 12:53:08.581355
71	Đã thôi quê dép nhà hóa quê bạn ghét. Thôi là được. Mượn vẽ hóa.	1	0	59	8	2023-07-13 10:52:57	2023-12-09 12:53:08.582328
72	Khoan bơi lỗi thuê thích trăng vàng quần làm. Đánh đã vá tám trăng cái. Xanh kim khâu yêu thôi.	1	0	95	99	2023-06-28 15:05:06	2023-12-09 12:53:08.58326
73	Thôi mây mượn vẽ được cửa. Ừ hàng nghỉ việc. Chỉ tám chìm mười mười xuồng.	1	0	96	43	2023-03-17 11:38:54	2023-12-09 12:53:08.584383
74	Xanh biển bàn chết mua. Con ác nước hết. Chìm ờ tôi hàng.	1	0	1	27	2023-04-22 04:35:33	2023-12-09 12:53:08.585367
75	Tím tím xanh tám khâu bơi quê bảy lầu. Thuê may bốn cửa chìm đá chìm. Ba vá thôi dép leo đâu bàn thuê đánh.	0	0	75	10	2022-12-22 23:42:49	2023-12-09 12:53:08.586367
76	Hai kim ghế ba lầu xuồng thuyền tím. Con không thuyền em máy gió xuồng việc. Mây xuồng ngọt.	0	0	57	24	2023-06-17 06:21:37	2023-12-09 12:53:08.587309
77	Thôi độc con mây. Hai hóa đập nha tám em đồng mướn đạp gì. Trời làm chìm độc tám em sáu.	1	0	17	34	2023-05-20 07:18:08	2023-12-09 12:53:08.588241
78	Năm bàn tôi mây. Độc đã núi một tủ thuyền lầu gió. Con hai thế nón leo cái tím đánh.	1	0	100	80	2023-03-10 13:48:42	2023-12-09 12:53:08.589158
79	Anh đá may vàng gì hương mượn máy không. Mượn chết độc nón gió. Xuồng tàu bơi thế đập độc nghỉ chết phá vàng.	0	0	49	32	2023-01-26 00:59:59	2023-12-09 12:53:08.590124
80	Lỗi bạn mướn lỗi. Thôi bạn ghét bảy ờ nhà. Áo ghét lỗi một tô.	0	0	24	28	2023-02-27 19:51:58	2023-12-09 12:53:08.591075
81	Ác việc bơi yêu. Đá may trời. Nhà đỏ tủ khâu mây đạp giày.	0	0	37	80	2023-11-24 16:36:00	2023-12-09 12:53:08.592201
82	Sáu hai thuyền khoảng đồng quê ngọt hai đập vàng. Đâu ừ năm tôi viết mướn. Được là năm cái á hóa.	0	0	52	86	2023-02-19 12:12:14	2023-12-09 12:53:08.593279
83	Tủ phá quần khoảng thuyền tủ nha. Kim làm mây được vá mua. Phá tám thôi sáu mướn máy mượn chín chỉ đập.	1	0	23	14	2023-03-25 03:06:53	2023-12-09 12:53:08.594241
84	Núi tô tôi ngọt. Hai đâu biết. Làm thì mướn đang mua ba yêu đạp lầu.	0	0	45	11	2023-11-29 15:38:10	2023-12-09 12:53:08.595173
85	Áo mượn khoảng gì bạn thích á. Ghế nón gió khâu khoan tui quê đập mượn. Đá ngọt may giày việc xanh trời biển đỏ hóa.	1	0	3	9	2023-04-27 01:28:28	2023-12-09 12:53:08.596153
86	Biết đạp tôi kim một. Mười ừ lầu bơi chỉ nước bè con. Nghỉ viết thôi.	1	0	39	72	2023-05-14 17:58:07	2023-12-09 12:53:08.597157
87	Ừ mây tủ mây giết đồng hương vá. Hàng đồng phá tủ bảy nhà ờ. Chết quê trời bạn tím nha chìm.	0	0	42	80	2022-12-30 02:17:34	2023-12-09 12:53:08.598118
88	Ghế hết xanh. Mây mướn đỏ. Tôi năm con phá chết làm nón cửa ờ.	0	0	30	40	2023-04-03 18:44:41	2023-12-09 12:53:08.599038
89	Tui xe mướn thế hết ruộng. Không kim làm phá hai hết thì. Nước núi áo đỏ đâu con.	1	0	84	27	2023-01-26 09:21:50	2023-12-09 12:53:08.600084
90	Leo may bơi thích kim không. Mây núi ngọt khoan trăng vẽ con trăng khâu quê. Mười xanh ừ nha em biết mượn bè gì tui.	1	0	22	91	2023-06-30 04:15:56	2023-12-09 12:53:08.601074
91	Thôi con mướn quần nón thuyền gì hết. Bảy bảy ngọt xe. Thương mười cửa may.	0	0	95	100	2023-06-19 09:23:11	2023-12-09 12:53:08.602008
92	Anh vàng hóa tủ. Bè đạp vàng độc cửa chín ghế. Đâu mua trăng nha khâu ghế yêu nhà đánh.	0	0	33	8	2023-02-19 06:41:48	2023-12-09 12:53:08.602998
93	Núi tui hương đánh khâu. Đã chín trăng viết vẽ ác phá bàn độc. Đạp phá hóa.	1	0	99	69	2023-06-21 03:10:21	2023-12-09 12:53:08.604016
94	Hương tui xanh biết vá dép tô. Bè thuê đâu viết. Quần quần ghế thế bốn chết kim.	0	0	43	12	2022-12-11 09:27:19	2023-12-09 12:53:08.604946
95	Nón không bàn con chết ừ dép đá khoan thế. Giết tám vẽ. Mây ghét ngọt cái nhà xuồng hết nha thuê.	0	0	76	86	2023-07-25 21:30:14	2023-12-09 12:53:08.605919
96	Yêu việc áo đạp. Nước hai vẽ cửa biết năm tủ bốn leo bốn. Biển hóa hết yêu xanh quê hết ruộng.	0	0	33	5	2023-07-17 10:10:05	2023-12-09 12:53:08.60692
97	Ba giết dép đánh một thuê xuồng. Cái ghế tàu gì không thế lầu. Là mây là anh thương đỏ cửa.	0	0	11	87	2023-11-16 02:31:14	2023-12-09 12:53:08.60788
98	Mây lỗi tàu việc tàu. Ác chết phá ba. Tui quần bè hết thích độc hóa leo nhà núi.	0	0	73	73	2023-04-19 23:17:30	2023-12-09 12:53:08.608831
99	Á phá hóa tủ việc đỏ trăng quần mua leo. Anh thì áo yêu lầu chín dép thương nghỉ tàu. Mây ừ tàu biển.	1	0	49	59	2023-08-28 03:24:56	2023-12-09 12:53:08.609843
100	Hóa núi thích ừ ừ vá. Con ba chỉ tím viết biển. Cái trời ờ.	1	0	94	53	2023-04-12 12:04:59	2023-12-09 12:53:08.610789
5	Cái đạp chìm mượn. Nhà quần tám thì ờ tám mười. Đánh thuê hai.	0	0	56	1	2023-01-13 14:19:25	2023-12-09 05:54:23.98776
47	Bảy tám lầu biển bốn khoảng thế tím ghét viết. Cửa thuê tím ờ áo là phá hóa mượn. Hàng biển chìm nha chết ác.	1	0	58	1	2023-07-05 18:25:56	2023-12-09 05:54:23.98776
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
1	1	1
2	2	1
3	3	1
\.


--
-- Data for Name: questions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.questions (id, title, content, isanonymous, viewcount, likecount, userid, acceptedanswerid, createdat, updatedat) FROM stdin;
1	Biển ba ghét hai việc khâu biển viết.	Mây tủ giết năm là cái ba. Leo tô không áo phá ghế. Đập làm bè gì.	1	31	0	53	\N	2023-11-03 16:35:14	2023-12-09 12:53:08.410044
2	Thế nghỉ chìm gió tôi.	Bốn tím nhà hết tô mượn đánh nón chỉ. Ác đâu làm thì hàng một. Áo giày quần thế tui á.	1	2	0	6	\N	2023-05-03 14:23:32	2023-12-09 12:53:08.411507
3	Vá tàu chỉ lầu năm ruộng thôi làm đang.	Nhà ác ruộng tàu leo bạn. Mướn ghế sáu biển hàng. Đập cái sáu đạp đồng núi bảy tôi.	1	18	0	65	\N	2023-06-10 14:41:29	2023-12-09 12:53:08.412666
4	Khâu vẽ đá dép thôi khoảng viết đâu.	Biển hết ghế chín đá bơi cửa thương. Ngọt chìm trời. Trời nhà bè máy cái.	1	51	0	14	\N	2023-05-19 11:15:48	2023-12-09 12:53:08.413754
5	Tui máy phá nha.	Vẽ tui cửa. Mười áo bảy. Hết một độc thuê hóa.	0	62	0	21	\N	2023-05-23 21:40:06	2023-12-09 12:53:08.414844
6	Nha đồng kim gì độc mướn.	Được thôi không may năm đá phá áo. Xanh thuyền quê cái lỗi mua ghét. Nước núi ừ khoan ác tôi ờ gió năm.	1	71	0	90	\N	2023-10-05 09:54:16	2023-12-09 12:53:08.415875
7	Nón kim mười quần.	Bảy đánh nón bạn áo làm chìm anh ờ. Nhà biển đang thương bàn anh tàu việc vẽ. Tàu nhà đâu vẽ đang đá giày bè tôi.	1	6	0	93	\N	2023-03-02 03:49:00	2023-12-09 12:53:08.416889
8	Ngọt bốn việc viết tám mười thôi giết.	Là hết ờ đập mười cái chỉ. Đỏ tô ác á. Mượn khoan ờ núi tủ mười đang trời.	0	70	0	65	\N	2023-05-23 08:58:44	2023-12-09 12:53:08.41797
9	Thế ba gì nha làm đánh chết độc tám.	Độc đã quê chỉ biển hai phá. Bè ngọt tủ em nón. Tôi ừ bảy mướn ghế hai khâu ba.	1	48	0	10	\N	2023-04-10 16:40:09	2023-12-09 12:53:08.419003
10	Xe đang tui anh năm thôi phá.	Tám quê tô tám hương thuê nha. Nha phá tôi bốn. Bảy thuyền đâu nhà vẽ năm khâu.	0	20	0	73	\N	2023-10-18 18:10:00	2023-12-09 12:53:08.419978
11	Ba ờ không tím em.	Bốn chín gì trời con cái chìm thích. Đá bè khoảng. Ghế bạn hết là đá quê hết.	1	19	0	65	\N	2023-05-21 12:40:58	2023-12-09 12:53:08.420941
12	Lỗi gì thôi yêu xe trăng ngọt quần.	Đang hết thương ba quê bàn vàng cửa khâu lỗi. Bốn ruộng đỏ đỏ xe thôi may vàng may. Đang bạn biển ngọt anh việc nón viết.	1	16	0	58	\N	2023-01-20 06:52:39	2023-12-09 12:53:08.421877
13	Ruộng mười nhà vàng.	Chín ghế mượn. Quần hết ác lỗi ác tôi em trăng. Ba thôi mây khoan tui trăng ba tàu hàng viết.	0	89	0	14	\N	2023-07-25 18:23:41	2023-12-09 12:53:08.422822
14	Con lầu giày hai ghét biết tàu bè mướn.	Việc em bàn khâu gió chết mượn. Sáu đạp máy trăng yêu đá hết nước núi bốn. Thuyền dép được làm chín leo nha đã.	1	30	0	94	\N	2023-07-08 14:51:14	2023-12-09 12:53:08.423771
15	Bè vàng nón ngọt bàn thích ờ.	Thuê quần thôi mười bơi hàng quần thôi vá. Thì cửa ừ. Làm đỏ tàu xuồng bạn thích đạp xe nước.	1	27	0	59	\N	2023-03-05 09:52:32	2023-12-09 12:53:08.424718
16	Xe vàng thế kim tôi đạp á viết đang.	Biết chỉ chín làm tôi sáu em. Bạn bàn xe. Con anh tàu lầu lỗi.	0	59	0	30	\N	2023-02-18 15:11:10	2023-12-09 12:53:08.425795
17	Vá vàng em đã thì yêu.	Đập việc tôi chết ờ xuồng. Ba ờ mượn mua đỏ nha gì vẽ. Máy thuyền mượn giày biết ừ.	1	85	0	16	\N	2023-09-24 19:53:49	2023-12-09 12:53:08.426803
18	Bốn em hương tô vẽ vẽ may.	Được đạp biển á xe mua. Đạp mười trời quần không. Tàu tô cái ờ thuê mua khoan yêu.	1	3	0	6	\N	2023-04-01 19:10:04	2023-12-09 12:53:08.427825
19	Ngọt đồng bạn xuồng anh gì bè ừ tàu.	Mua đá lầu tám đâu hương vá mây thuê mây. Ghét trăng ờ máy gió nón. Biển đã trời ba hương nha.	1	86	0	97	\N	2023-08-16 21:54:30	2023-12-09 12:53:08.428808
20	Quê độc bạn núi chìm.	Đâu bè thương. Thì vá hai gì khoảng nha đạp em. Đã giết giày làm nón hóa hàng khoảng.	1	54	0	12	\N	2023-11-04 07:26:56	2023-12-09 12:53:08.42984
21	Giày hương may anh vá ừ thuê con tui tủ.	Gió mười thuyền đang ba em không được đâu. Bảy quê tím. Vàng tô vàng may không làm chín là vẽ khoảng.	1	21	0	24	\N	2023-08-03 13:53:27	2023-12-09 12:53:08.430893
22	Phá bạn đánh độc khoan bốn đánh.	Áo núi mướn xanh phá bàn xe anh thế. Đồng hàng anh hóa nha thuyền tui ừ á. Ghét gì yêu độc sáu may.	0	73	0	26	\N	2023-04-29 03:49:42	2023-12-09 12:53:08.431906
23	Á mây mây viết viết tám ruộng bốn thích ờ.	Đỏ quê bạn phá vàng bảy bàn tám nghỉ. Đá ờ á kim. Ghét vẽ nhà trăng chìm áo.	1	92	0	42	\N	2023-02-03 08:42:34	2023-12-09 12:53:08.432988
24	Cái bơi xuồng là sáu hương thôi nghỉ quần.	Ngọt mượn may vá bạn may mua ngọt. Ba hàng yêu việc mây. Đỏ khoảng thôi khoảng gió ác chỉ thế ghế chín.	0	47	0	40	\N	2023-07-24 06:39:46	2023-12-09 12:53:08.434046
25	Khâu năm bốn hai tím máy mười thế mượn.	Vàng vá một bàn đỏ hết vàng núi ruộng gì. Kim bạn xanh. Thôi hết tám xe khoan biển bạn cửa đập.	0	99	0	75	\N	2023-04-14 14:50:34	2023-12-09 12:53:08.435035
26	Bốn tôi mướn nghỉ leo tôi thuyền.	Tui tàu phá núi cửa dép đồng. Ừ anh đạp đồng em ruộng thôi. Núi ngọt xe mây đang.	0	70	0	78	\N	2023-10-03 22:02:56	2023-12-09 12:53:08.435997
27	Áo anh vàng ghế leo giày biết.	Quê ghế nghỉ đá hết ruộng biển. Đồng á gì con tím đá. Hương bè ngọt hết nhà ruộng.	0	52	0	41	\N	2023-02-07 01:26:58	2023-12-09 12:53:08.436933
28	Nha đá đỏ trời thế quê quê nhà.	Gì ghét con ừ lỗi con tàu phá. Chỉ nước được làm. Chết áo ruộng tàu tô việc máy áo xe lỗi.	1	50	0	75	\N	2022-12-10 11:47:38	2023-12-09 12:53:08.437849
29	Đâu vẽ chết bè xanh.	Bốn tôi ờ vàng. Đánh bốn mây xuồng thuê. Giày lầu vẽ ừ đang.	0	27	0	85	\N	2023-09-09 13:31:52	2023-12-09 12:53:08.438755
30	Thương bàn mười vàng đá thế mua tô.	Nhà đập thích đánh khoảng tủ hết tàu. Xuồng thương lầu. Vàng thuyền đỏ.	1	18	0	1	\N	2023-05-11 03:12:43	2023-12-09 12:53:08.439821
31	Trời hương núi nhà áo phá.	Mượn ờ mua là khoan gió ờ. Đánh mướn bốn đạp lầu đá kim. Tàu đỏ ngọt viết máy.	0	56	0	17	\N	2023-10-22 19:20:24	2023-12-09 12:53:08.440757
32	Tím bàn đâu em ác bơi mua khoan.	Trăng bốn vẽ ghét biết. Tôi đâu viết. Á không độc quê biết xuồng bè.	1	44	0	8	\N	2023-09-24 18:51:14	2023-12-09 12:53:08.441678
33	Đỏ một bàn.	Bè cửa gì hết sáu trời mướn ghét thế đang. Gió độc á đạp ghế biển leo. Hết xuồng máy tui ba tô năm.	0	22	0	67	\N	2023-01-22 00:30:19	2023-12-09 12:53:08.442595
34	Ừ biết tô bốn núi.	Viết em tô. Leo bảy nha. Quần xanh xuồng tàu kim nón hóa.	1	55	0	16	\N	2023-05-08 17:47:41	2023-12-09 12:53:08.443575
35	Kim thích mua lỗi.	Đá thương ruộng ba hết thì mướn đánh vẽ quê. Ba tủ đánh thì tôi vẽ á không áo bè. Cái á mười sáu ghét thôi giết ờ.	0	75	0	73	\N	2023-01-27 05:04:58	2023-12-09 12:53:08.444491
36	Đạp chìm nước mướn thuê làm phá xe thương anh.	Chìm thuê vẽ máy làm ghét gì. Mây nha tui hương quần vá làm viết chết. Đánh cửa con.	1	20	0	17	\N	2023-08-11 14:21:29	2023-12-09 12:53:08.445403
37	Bơi là vá trăng bốn yêu gió mướn biết.	Anh xanh chín nhà đồng mười tô hai đã năm. Mướn đã á nước. Nước quần bạn.	1	50	0	6	\N	2023-10-07 00:59:41	2023-12-09 12:53:08.446617
38	Vẽ ba viết biết năm tàu cái tôi.	Phá thì đạp đánh. May nón đồng tím em. Dép thôi năm chết chỉ.	0	1	0	56	\N	2023-10-19 18:07:05	2023-12-09 12:53:08.447691
39	Chết không nước cửa mướn.	Bè tủ đã xuồng đập giết mua năm hương đập. Áo thế độc chìm mua đã bảy ruộng hai. Bè leo núi nha vẽ chìm đỏ.	0	30	0	20	\N	2023-02-28 13:06:12	2023-12-09 12:53:08.448642
40	Hai em tím đánh hàng tám hương khoảng.	Lầu tám áo nghỉ năm đạp em thì. Xe ba mười yêu chìm trời bè bè tủ cửa. Bạn bè gì khâu xe.	0	51	0	79	\N	2022-12-19 10:35:37	2023-12-09 12:53:08.449642
41	Là hương đã.	Tôi mượn khâu thuê làm mướn tám tui. Thuyền may hương nón con. Ác một bốn chín.	0	21	0	45	\N	2023-05-26 10:52:11	2023-12-09 12:53:08.450787
42	Tím tủ mượn hết viết mượn nhà đạp kim.	Đạp yêu bè đã. Xe ghế đá bảy trăng biển một. Chết việc quê việc ghét.	0	65	0	2	\N	2023-02-14 17:10:25	2023-12-09 12:53:08.451758
43	Đang một mượn đá đồng leo con tui núi.	Dép mượn vàng đánh con thôi phá ừ bảy mướn. Ờ nón yêu vàng biết không. Tôi biển đồng thích không may.	1	100	0	7	\N	2023-06-16 08:54:29	2023-12-09 12:53:08.452726
44	Cái mướn biển thì thôi máy.	Nón leo trăng hết phá. Bơi năm thích khoan sáu nha thích hóa giày mướn. Đỏ chín chỉ lầu cái quê.	0	20	0	66	\N	2023-08-26 19:25:27	2023-12-09 12:53:08.453767
45	Bảy không vẽ bè mười.	Xuồng phá vá mướn. Tím sáu lầu mây tui đập sáu bảy. Á viết thuê xe á á.	0	78	0	32	\N	2023-05-14 00:12:24	2023-12-09 12:53:08.454705
46	Tủ máy tám bảy mua leo đồng chết hương giết.	Thế một ghét đang em tím. Bạn hóa chín. Vàng khâu tô mười chín trời.	1	3	0	85	\N	2023-02-18 02:57:38	2023-12-09 12:53:08.455668
47	Bè thì giày tui hóa gì khoảng.	Độc biết thuê mười chín chìm. Lầu ba tám ngọt khâu viết gió biết vẽ. Đạp nghỉ xe nha ghét hóa tím lỗi.	1	52	0	94	\N	2022-12-19 11:02:45	2023-12-09 12:53:08.456621
48	Sáu cửa nón.	Xe thế hết ngọt anh mười cái ghế. Thương may ờ thế giày không mướn xe con. Mười nhà tô leo chỉ làm việc.	0	1	0	94	\N	2023-05-15 12:25:33	2023-12-09 12:53:08.457583
49	Nước mướn nhà trời nghỉ xanh chìm độc.	Anh đập tám hết đã bạn. Mây tôi ba. Xe may ghế.	0	31	0	5	\N	2023-11-20 17:11:26	2023-12-09 12:53:08.458562
50	Mượn năm xe chìm.	Nón không thôi xanh yêu nhà tôi sáu. Xuồng đập sáu bơi lỗi gì tàu mượn. Một nước viết bè chín độc.	1	92	0	85	\N	2023-07-05 11:34:29	2023-12-09 12:53:08.459507
51	Gió nhà đạp đã không.	Ba tám đâu kim đánh khâu leo bàn xe. Quần chín ghế leo khoan tím khoan em mười hàng. Ờ mua bơi ác ừ hương ngọt.	0	70	0	37	\N	2023-02-08 05:36:58	2023-12-09 12:53:08.460631
52	Núi không cái tím đạp máy.	Trời vá thì. Phá thuyền mây làm độc lầu năm nha khoan bốn. Hóa tô bốn đập nước tôi thuê.	0	77	0	33	\N	2023-05-17 07:31:21	2023-12-09 12:53:08.461659
53	Kim thôi cửa vàng hương.	Khoảng vá không hương ờ em bơi nghỉ chết. Bảy kim thích thôi. Bàn nón hết.	1	25	0	46	\N	2023-05-20 22:00:17	2023-12-09 12:53:08.462737
54	Ruộng hai tám đã khâu.	Giết lỗi làm bè tôi vẽ hết quê. Hết tô thôi. Đâu thuê tám không.	1	38	0	11	\N	2023-09-10 15:10:31	2023-12-09 12:53:08.463705
55	Làm đập núi xanh.	Hết là trăng. Vàng phá thuê thương nước hương. Ba vá hương tàu đá đập dép tàu.	1	22	0	20	\N	2023-03-27 01:52:17	2023-12-09 12:53:08.464682
56	Khoan hàng tám á tủ.	Đồng may mướn bảy. Kim yêu ờ. Đập độc đỏ năm áo leo hóa cửa đánh ừ.	1	11	0	70	\N	2023-07-26 20:58:23	2023-12-09 12:53:08.465664
57	Thì vàng đập bốn vẽ tàu phá yêu.	Thì tủ em bàn độc thương thì. Bốn hương ừ đá dép. Mười xanh một phá tủ nha việc leo.	0	21	0	10	\N	2023-10-22 19:39:55	2023-12-09 12:53:08.466776
58	Mây trăng kim không vá.	Chết núi nước vá leo lỗi. Thì gió ba biển chết thế trời thương đạp. Đang lỗi tàu biển.	1	34	0	24	\N	2023-02-11 02:58:09	2023-12-09 12:53:08.46831
59	Ghét giết viết máy nghỉ bạn đỏ thuê hai chín.	May thuyền đạp. Nghỉ đỏ quê vàng đánh nghỉ nha ruộng. May tám giày trời bốn ngọt.	0	94	0	53	\N	2023-06-01 20:28:15	2023-12-09 12:53:08.469433
60	Thế á phá thích.	Đâu phá năm nha mượn ba mượn quần tám. Một đá khoan tủ đâu may tôi may thích trăng. Mười đang khoan giết đâu yêu.	0	98	0	40	\N	2023-06-01 02:41:45	2023-12-09 12:53:08.47043
61	Biển là đá bàn quần tàu vẽ.	Tàu giày đang may hàng là lỗi. Đánh dép mượn việc xuồng. Đá khoảng may xuồng hết.	0	47	0	83	\N	2023-05-04 09:12:37	2023-12-09 12:53:08.471454
62	Gì bàn vá hai ghế việc nhà ờ đâu khoảng.	Đang phá đỏ á sáu á dép leo kim đỏ. Đâu may chìm vẽ yêu vẽ vẽ thế á. Đâu năm bè máy sáu lỗi phá.	0	75	0	95	\N	2023-03-14 15:59:48	2023-12-09 12:53:08.472636
63	May chỉ áo.	Đánh đồng hương ba nước là. Thì trời việc. Bàn hàng đâu kim đạp ghế.	1	7	0	20	\N	2023-05-28 21:07:39	2023-12-09 12:53:08.473819
64	Thích thôi trời quê.	Ghế giết tím đâu. Tàu đạp chìm đã xanh bè may gì. Nghỉ đá được nước lầu.	0	34	0	84	\N	2023-05-22 07:05:29	2023-12-09 12:53:08.474974
65	Đập mười tám tím nha bàn leo việc may.	Leo việc nón thương gì ờ. Khoan em mây đạp mướn hết hóa. Ờ khoan làm ba nhà thương.	1	87	0	53	\N	2023-04-15 00:09:24	2023-12-09 12:53:08.476058
66	Dép vàng dép máy xe.	Viết núi mười khâu tủ nước yêu đạp may đạp. Dép gió ghế quê áo thuyền biển lỗi. Đâu một khâu.	0	74	0	69	\N	2023-09-11 21:13:45	2023-12-09 12:53:08.477117
67	Độc ừ phá trời xuồng biết hết.	Biển tô nón làm leo ghế vàng đỏ được khoảng. Lầu xanh tôi. Tám bàn phá đã bàn hóa nón.	1	2	0	24	\N	2023-01-25 13:01:34	2023-12-09 12:53:08.478124
68	May mười ừ.	Nước năm thì ừ. Biết ruộng mượn phá tám. Viết ác mượn viết nghỉ thì gió gió.	0	28	0	21	\N	2023-12-06 14:45:10	2023-12-09 12:53:08.479114
69	Thương đồng đá mây.	Chết máy nha. Mượn chỉ ghét nước xanh con cửa tô. Bơi không việc tàu dép phá nước.	1	42	0	99	\N	2023-12-05 19:22:20	2023-12-09 12:53:08.480121
70	Vàng chín mướn một vá mượn chỉ nước.	Tím bốn nghỉ vàng sáu chìm. Gì hóa thôi tui. Được nghỉ hết khoan một thuê.	0	49	0	63	\N	2023-11-19 10:52:09	2023-12-09 12:53:08.481204
71	Đỏ ngọt đạp việc khâu lầu anh lầu.	Leo con đá tui. Đánh đâu chìm. Đâu cửa đá trời tím thích xuồng khoảng dép.	0	25	0	89	\N	2023-07-09 06:56:55	2023-12-09 12:53:08.482305
72	Thế nước ruộng bảy bốn xanh nón là cửa núi.	Việc trăng cửa chết. Tô biết trời. Thuê biển chết đã giày may nhà.	0	68	0	82	\N	2023-04-27 15:29:49	2023-12-09 12:53:08.483298
73	Quần lầu trăng tô đập viết anh là.	Ngọt trăng hương làm thế. Kim cửa xe hóa. Hương ác mướn xe bảy thuê năm.	1	32	0	81	\N	2023-01-04 15:34:30	2023-12-09 12:53:08.484286
74	Giày đánh không vẽ gió tôi cửa chết.	Thuê ác mua đỏ chỉ thì năm thích tàu. Thế con là á cửa phá biển tô nhà đã. Cái hóa thôi ruộng hai khoan.	1	72	0	71	\N	2023-06-05 12:07:32	2023-12-09 12:53:08.48525
75	Thương nghỉ ba mây gió tô lầu thế là may.	Leo ờ khâu nghỉ. Mượn khâu bạn đá khoan mua không. Kim ừ trời.	0	71	0	39	\N	2023-10-06 03:39:58	2023-12-09 12:53:08.486212
76	Áo ghế sáu leo xanh thì may tủ.	Tàu áo ác là bảy chín. Ghét phá á bơi trời nón may bàn đồng đã. Giày áo tám xuồng thôi đỏ quần thôi đập.	0	10	0	42	\N	2023-05-15 06:45:01	2023-12-09 12:53:08.487147
77	Hương thuyền nón khoan nhà.	Chìm thì viết được tô lầu biết. Con đang năm thuê đỏ thì. Đạp anh ghét vàng núi mua.	0	26	0	27	\N	2023-05-06 06:01:02	2023-12-09 12:53:08.488169
78	Bạn á xuồng mười.	Vá vá khoan ghế nón đang đạp vẽ con. Vá giết khoan bơi leo quần đạp chết may ghế. Bơi chìm ngọt ờ nón mướn quê được làm.	0	56	0	78	\N	2023-06-02 09:04:38	2023-12-09 12:53:08.489203
79	Nón anh lỗi hết nước.	Mướn xe dép mượn hết một ba quê mướn đỏ. Nước nước được nghỉ hai ác mướn. May hương mười giày cái trăng mượn bơi.	0	10	0	57	\N	2023-07-02 09:47:19	2023-12-09 12:53:08.490233
80	Ba đá tàu ừ ừ nghỉ thôi cửa.	Thích viết gió phá lầu chìm đỏ anh sáu con. Nha quê gì xe. Đánh viết áo chết áo.	0	19	0	80	\N	2023-07-19 21:13:54	2023-12-09 12:53:08.491223
81	Ghét hết mướn tím tám chìm năm mây.	Là khoan thuyền mây. Đánh thuyền ừ á tủ. May đập đang ác hai trăng lỗi giết.	0	73	0	22	\N	2023-10-23 13:40:05	2023-12-09 12:53:08.492159
82	Chỉ hương là gió đạp hàng biển.	Ừ năm nha. Nón thuê năm bạn xanh. Gì được được vẽ đạp mười.	0	10	0	57	\N	2023-02-06 12:58:15	2023-12-09 12:53:08.493102
83	Máy sáu trời biển hàng.	Nước tô ba nha. Thích thương quê khâu đá bè bơi. Biển tủ vá yêu ghế cửa em.	1	7	0	27	\N	2023-08-27 17:17:41	2023-12-09 12:53:08.494026
84	Tủ thuê đồng đang nước núi tui xuồng.	Đá đồng giày thích ghét may nước. Gì bảy đánh thuyền biết đã. Lầu biển giày một nha trăng sáu chín mây bàn.	1	46	0	2	\N	2023-08-02 10:52:51	2023-12-09 12:53:08.495082
85	Tàu đá thôi hóa kim tôi thì ờ núi trời.	Biển máy vẽ hương. Kim gì quần việc thế bạn. Khoan chín bạn đập vá một.	1	18	0	58	\N	2023-01-05 09:21:00	2023-12-09 12:53:08.496055
86	Hết vẽ ừ.	Gió không nón quần bốn. Biển quê vàng đập bạn bơi. Tủ biết xe.	0	90	0	12	\N	2022-12-22 12:17:19	2023-12-09 12:53:08.497009
87	Bơi thuyền bảy nhà hóa chỉ chết xanh ừ trời.	Tô chỉ lỗi ác ờ được đồng. Ruộng tủ ba trời chỉ quần hóa trăng. Giày cửa nhà nhà trời mây nhà độc tôi đâu.	0	45	0	73	\N	2023-10-12 13:44:57	2023-12-09 12:53:08.498011
88	Tôi sáu nước nha kim á tô cửa.	Tàu xuồng nhà con. Viết bạn ừ tám đâu vẽ con ác ác yêu. Chín khoan bàn con viết ghét nghỉ ngọt.	1	99	0	50	\N	2022-12-25 23:12:27	2023-12-09 12:53:08.498995
89	Ghế thuê đỏ vàng chìm quê độc hương trời thích.	Cửa gì đỏ hai trời ba hết lỗi cái hai. Vàng mua đập. Áo hết thuyền dép thương chỉ cửa tím chết chỉ.	1	93	0	78	\N	2023-09-12 14:56:40	2023-12-09 12:53:08.499936
90	Bốn xe biển chỉ đá leo biết đỏ sáu.	Ừ tím là khoan nghỉ yêu xe thì. Nước đạp máy ba bơi bơi bạn được khoan bàn. Trăng trăng á tui đá nón tàu ba lỗi.	0	6	0	46	\N	2023-09-11 16:05:03	2023-12-09 12:53:08.500944
91	Thuê gió bơi hàng bè sáu ừ.	Vẽ trời núi xanh tám. Được chỉ thuyền may phá con bàn hết xuồng. Hết quần thì leo ghế nhà làm cửa ghế.	0	83	0	24	\N	2022-12-27 00:05:22	2023-12-09 12:53:08.501933
92	Mười đã đang đập là tám khoan.	Độc tui mua máy. Đã ghế lầu. Vá anh năm mây đang tô thích.	0	57	0	1	\N	2023-03-19 18:41:41	2023-12-09 12:53:08.502947
93	Khoảng thuyền tôi lầu trăng nón nghỉ.	Em dép quê phá bảy ghế mua giết xanh quê. Thế thuê sáu chìm. Chìm biển mua ác bốn thôi.	1	98	0	5	\N	2023-05-17 08:12:26	2023-12-09 12:53:08.503916
94	Việc quê năm.	Hết vẽ em mượn khoan thế lỗi nha. Quần trời hóa ừ đá đã đang. Đâu là bơi bè tám đạp mua.	0	54	0	26	\N	2023-10-08 10:15:04	2023-12-09 12:53:08.504856
95	Hàng đập viết việc độc lầu độc.	Đạp mười đạp giết trời chỉ tám cửa may. Việc sáu khoảng ngọt hương đánh. Khoảng vẽ đã em.	1	86	0	48	\N	2023-03-28 12:10:25	2023-12-09 12:53:08.505824
96	Mây bốn quần chín anh.	Đỏ ghét núi chỉ. Đâu quần bạn tui thương đá ngọt máy áo. Quê gió trời hàng đánh.	1	61	0	77	\N	2023-08-07 01:06:56	2023-12-09 12:53:08.506835
97	Thuê tui được bơi độc biển áo.	Xuồng em bàn việc lầu trăng hương thôi khoảng. Mượn ruộng tui độc. Tàu thế đá chỉ tím.	0	46	0	81	\N	2023-08-02 09:19:37	2023-12-09 12:53:08.507913
98	Biển biết mây kim.	Máy ruộng trời chìm đâu tủ nghỉ leo nón ghế. Tủ biển thế. Xe tím bè mượn yêu biển một.	0	31	0	71	\N	2023-08-16 00:21:19	2023-12-09 12:53:08.508955
99	Kim năm một.	Đâu hết việc dép chín đánh tôi đâu đang ngọt. Hết khoảng nghỉ may hai nghỉ là giết mua. Bè vàng mướn mướn vàng nước may máy nha.	0	71	0	20	\N	2023-03-15 14:14:34	2023-12-09 12:53:08.509931
100	Bạn giết máy đá anh hóa.	Tô xe cửa mượn đánh bơi quê đánh tô xe. Bốn cửa tôi ác phá yêu. Áo đang anh đá bè vẽ vàng tím.	1	45	0	69	\N	2023-07-11 07:08:21	2023-12-09 12:53:08.510887
\.


--
-- Data for Name: tags; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tags (id, tagname, count, color) FROM stdin;
1	khoan	18	#02345a
2	không	51	#7e694f
3	bốn	82	#645a06
4	áo	68	#0a1346
5	mượn	1	#0d4a55
6	ruộng	64	#730928
7	đâu	47	#0d1d4f
8	một	27	#673c74
9	thương	88	#1d4439
10	là	30	#244323
11	chết	44	#250d0c
12	ghét	24	#44023a
13	việc	89	#3b4144
14	ngọt	47	#562c55
17	may	93	#2c5933
18	gió	10	#143015
19	phá	61	#6b2963
20	mười	30	#6e2146
21	nghỉ	15	#190e1c
22	máy	56	#445867
23	á	70	#53712c
24	bàn	83	#29395f
26	bơi	60	#2d5921
28	hóa	86	#277c2a
29	mây	96	#3b3e2b
30	quần	61	#044b68
31	mướn	91	#01375b
33	sáu	91	#5d6705
34	em	23	#164336
37	chìm	50	#044b2d
39	hương	93	#583874
40	tui	19	#4f564d
41	viết	44	#4a121a
43	hai	51	#526138
44	ba	94	#644532
45	bạn	6	#51616b
46	tám	80	#7d0a03
47	anh	2	#033152
50	tô	45	#0d782d
51	giết	66	#700626
52	trời	90	#3b7b01
53	vàng	79	#2a4877
54	đỏ	20	#493a1f
55	đập	78	#7b7d77
57	đánh	15	#2c7574
58	đá	60	#6b1d06
59	giày	1	#4d2a18
60	ghế	31	#361f48
62	thôi	21	#303e34
68	thế	69	#07636c
69	đang	33	#6b7373
72	mua	65	#1e697a
73	khâu	54	#084d2e
75	chỉ	89	#305617
76	ác	86	#6c366f
80	vá	23	#170125
82	lầu	99	#363511
87	thích	60	#047470
89	tủ	53	#61105e
90	kim	100	#121633
91	gì	53	#565603
96	trăng	31	#74113a
99	dép	95	#7e1b67
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
1	Hồng Liêm Bùi	S5dsqU3pQAla8s9	QuangLinh.7koan@gmail.com	100	0	2023-08-11 18:42:24	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/1085.jpg	20188206	chết	thế	mua	Lỗi chết tám em bảy mười chìm. Mượn thì ờ đánh đạp tím áo. Lỗi bàn cái yêu hàng hương bảy đâu.	1	2023-12-09 12:53:08.297918	2023-12-09 12:53:08.297918
2	Đình Nhân Đoàn	nmx3Jf5GabjnAxf	PhuocThien.Le90@hotmail.com	13	0	2023-08-18 22:20:09	https://avatars.githubusercontent.com/u/12536039	20205276	ghét	hai	thuyền	Khoảng ruộng tàu. Không tím làm. Thôi vàng cái bè quê.	0	2023-12-09 12:53:08.29999	2023-12-09 12:53:08.29999
3	Khánh Hằng Tô	tbDPRWkJR8yEiB1	SonCa.Truong@yahoo.com	41	0	2023-01-01 05:58:28	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/1114.jpg	20232795	thuê	vá	đang	Ruộng biết tàu xuồng trời nón. Lỗi thuê hai hương bốn vàng nghỉ ghét khoảng. Thì gì bạn làm hai giày ngọt á á việc.	0	2023-12-09 12:53:08.301458	2023-12-09 12:53:08.301458
4	Đắc Thái Trương	niv237apuP11wC6	HanhPhuong.Phung68@hotmail.com	28	0	2023-10-19 01:08:59	https://avatars.githubusercontent.com/u/22616782	20234804	bốn	vàng	vàng	Ghế tui tủ vàng phá nón ba nhà không ác. Nước á em ghét chìm nhà may mây thôi. Mây nha tủ nhà biết chỉ đỏ chín trăng hai.	1	2023-12-09 12:53:08.302752	2023-12-09 12:53:08.302752
5	Uyển Như Nguyễn	USs8pEOV26juhYw	HaiSan65@gmail.com	86	0	2023-01-14 00:52:20	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/405.jpg	20230582	tui	tàu	đá	Tôi chín thích không bốn em tím đá biết quê. Hóa thế trăng. Con ghét chết áo mượn quần tui bè.	1	2023-12-09 12:53:08.304103	2023-12-09 12:53:08.304103
6	Kim Đan Mai	51oju0teBp8Ia2b	MyTram_7ko64@hotmail.com	55	0	2023-03-05 21:07:20	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/1072.jpg	20231166	đạp	leo	ghét	Vàng anh độc là chết. Viết ruộng tôi em. Vàng lỗi quần áo mười chín.	1	2023-12-09 12:53:08.305275	2023-12-09 12:53:08.305275
7	Hữu Tân Vương	YJPQLMxXt3gP2_H	VanLinh.Pham@hotmail.com	38	1	2023-11-13 06:25:13	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/340.jpg	20153470	đâu	máy	núi	Sáu đá đá hết đồng ghế biết đang anh khâu. Tám xuồng sáu tô sáu việc hết. Thuyền biển làm tủ đã kim viết thuê hàng đá.	1	2023-12-09 12:53:08.306486	2023-12-09 12:53:08.306486
8	Mỹ Yến Hồ	hzRzzkkjzOLQ0KN	ThuongKiet.Hoang8@yahoo.com	93	0	2023-02-27 10:07:06	https://avatars.githubusercontent.com/u/19432572	20167867	khâu	bè	trăng	Biết đá bạn mua. Khoảng biết thế nhà con biển hóa lỗi. Một biển mướn khâu nghỉ vàng sáu con chìm á.	1	2023-12-09 12:53:08.307749	2023-12-09 12:53:08.307749
9	Tuấn Minh Bùi	Hrlo9magzPERmGO	BanMai_7koan11@gmail.com	83	0	2023-01-16 09:36:48	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/630.jpg	20145597	ghét	đâu	giày	Dép sáu thương ba. Vẽ bàn lỗi ngọt việc mua thích gì mượn. Việc nha trời giày quần tui mây đang lỗi bốn.	0	2023-12-09 12:53:08.309069	2023-12-09 12:53:08.309069
10	Tuấn Khải Phùng	lSOilVtKq03TAHW	HamNghi_7kinh38@yahoo.com	57	0	2023-05-27 07:16:01	https://avatars.githubusercontent.com/u/19764557	20215615	đá	tám	không	Hương em chín không quần núi mướn mười áo hàng. Việc biết khâu xe may nón đá. Anh chỉ tô nước tôi trời nón thuyền hai ờ.	0	2023-12-09 12:53:08.310337	2023-12-09 12:53:08.310337
11	Danh Sơn Đinh	npAZoY01TzZNc9K	ThanhHoa.Le@yahoo.com	59	1	2023-01-20 21:12:57	https://avatars.githubusercontent.com/u/6301924	20187828	quần	gió	thuyền	Viết may biết không ruộng trăng. Đạp ghét làm một khoảng bốn bè. Ghét giày leo lầu thế tám.	0	2023-12-09 12:53:08.311668	2023-12-09 12:53:08.311668
12	Vân Khanh Tô	HsdP81dRmUw8w9V	HoaiVy.To@yahoo.com	44	1	2023-03-23 07:34:39	https://avatars.githubusercontent.com/u/10826256	20199585	hàng	chỉ	tủ	Tám bơi biển đồng kim mua thuyền độc khoảng. Không nước xanh được đạp khoan tô tám trăng áo. Đâu lỗi dép.	1	2023-12-09 12:53:08.313246	2023-12-09 12:53:08.313246
13	Minh Minh Tăng	5Ect3NiqCzfrjKG	NgocThy.7kinh@yahoo.com	86	1	2023-03-25 05:13:16	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/107.jpg	20149303	mượn	biển	xe	Ác khoan ừ đâu bốn ghét xe. Yêu đâu xuồng chín may tím thuê ruộng nón. Đã anh thế.	1	2023-12-09 12:53:08.314554	2023-12-09 12:53:08.314554
14	Đại Hành Phùng	WxqtJ3KiwuTAsT_	HongChau_Phan20@yahoo.com	44	0	2023-07-21 15:12:21	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/466.jpg	20162674	mười	khoảng	mười	Leo hương lỗi ừ mua tui. Cửa ghét cửa áo tám đập bàn anh hai. Giày chín trăng.	0	2023-12-09 12:53:08.31572	2023-12-09 12:53:08.31572
15	Ngọc Trụ Trịnh	svpKJPG0TUESBqG	ThyTruc.Tran67@gmail.com	8	1	2023-03-28 20:46:58	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/210.jpg	20192322	á	bè	năm	Sáu giày việc đá ghế. Con ừ cái vẽ đỏ. Nghỉ hương mây thế bè.	1	2023-12-09 12:53:08.316789	2023-12-09 12:53:08.316789
16	Huân Võ Lý	d6oI3BdW3dVEDlp	TuongVi_Ha@yahoo.com	22	0	2023-08-13 00:46:32	https://avatars.githubusercontent.com/u/86990536	20195310	đang	nha	thế	Đâu xanh hàng làm gì mượn mướn năm. Mượn đồng tím. Bàn nón đỏ á mây độc thế hàng ngọt may.	1	2023-12-09 12:53:08.317848	2023-12-09 12:53:08.317848
17	An Nhàn Trịnh	1VDSfcfHlob8m5h	7kucKhai96@yahoo.com	6	1	2023-07-13 07:21:45	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/490.jpg	20154136	viết	ngọt	thế	Cái hương một đập. Hai vẽ ghét gì hóa nghỉ mây nha vẽ. Tàu đâu kim đâu thuê.	0	2023-12-09 12:53:08.318904	2023-12-09 12:53:08.318904
18	Kiến Văn Mai	DfbkNAl8XTqOsIW	AnNam_Vu@yahoo.com	39	1	2023-08-29 10:12:57	https://avatars.githubusercontent.com/u/62190270	20170816	ừ	nghỉ	cửa	Tám giày đang cửa mướn nha độc. Thôi việc đâu chín ừ việc ừ. Biển chết đạp bạn.	0	2023-12-09 12:53:08.319935	2023-12-09 12:53:08.319935
19	Ánh Lệ Dương	hwh8giFA_fya3We	7kongQuan_7koan59@gmail.com	76	1	2023-08-12 22:38:43	https://avatars.githubusercontent.com/u/34582303	20165326	leo	bè	ác	Tàu bảy xe giày không khâu độc biết. Ruộng đã vá ngọt xe phá viết một. Tủ tám nha vá hóa nước khoan em ghét bảy.	0	2023-12-09 12:53:08.321075	2023-12-09 12:53:08.321075
20	Diệu Ngọc Nguyễn	7IjzkmYT0pDjPi_	QuocAnh73@gmail.com	56	1	2023-02-17 14:04:59	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/263.jpg	20195637	mây	nước	khoan	Em ngọt biển giết ngọt đỏ bạn bơi thôi. Xe ba trăng may độc nghỉ bè. May em xuồng nón tôi anh mướn.	1	2023-12-09 12:53:08.322327	2023-12-09 12:53:08.322327
21	Trường Liên Đỗ	rkjTvemcXtk633a	SonLam_7kao13@gmail.com	15	0	2023-10-24 06:55:34	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/309.jpg	20174287	bàn	nón	nhà	Biển hàng tô sáu xanh thuyền mượn đánh. Mướn lỗi yêu giết hết. Đánh con con bạn một ghế làm năm ờ.	1	2023-12-09 12:53:08.323461	2023-12-09 12:53:08.323461
22	Thu Việt Tô	RoJU2UQ8NAgWaIL	LocUyen.Ly64@hotmail.com	5	0	2023-05-10 16:59:08	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/1059.jpg	20155451	năm	bốn	quê	Bốn độc làm mua vàng trời ghét làm đập giết. Chìm nha là ừ làm bè may gió một thương. Viết thế hàng thì chín bàn chỉ tôi thế.	0	2023-12-09 12:53:08.324508	2023-12-09 12:53:08.324508
23	Hải Sinh Đoàn	bF1RUaOeEs7xdMS	MaiKhanh99@yahoo.com	49	0	2023-08-15 19:11:02	https://avatars.githubusercontent.com/u/15173859	20208862	con	là	tủ	Hàng leo hương biển. Mây dép bạn tím ừ hóa quê. Tám ờ máy vá nghỉ ngọt bốn vẽ hương.	0	2023-12-09 12:53:08.325601	2023-12-09 12:53:08.325601
24	Thảo Linh Hồ	WJyKCxN8k8YXMx5	TuanTrung27@gmail.com	88	0	2023-03-23 11:52:46	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/683.jpg	20153678	bảy	mượn	áo	Đang thì mây bạn vàng cái làm bàn bơi. Ác bốn lầu dép yêu tui hương ruộng tàu được. Giết đánh mây trăng không thích nhà.	0	2023-12-09 12:53:08.326713	2023-12-09 12:53:08.326713
25	Bình Định Trương	awoxxZSK1k3IMPV	ThuHau_Ly59@gmail.com	100	0	2022-12-16 10:07:23	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/68.jpg	20170403	xanh	ruộng	được	Một quê anh vá tui. Tàu viết thế. Cái anh đang gì leo tôi vẽ thích.	1	2023-12-09 12:53:08.327825	2023-12-09 12:53:08.327825
26	Khánh Hoàng Phạm	vLk4hJLiEha30kp	TrieuThanh67@hotmail.com	58	1	2023-08-15 00:59:09	https://avatars.githubusercontent.com/u/23933214	20211451	việc	đập	mười	Bè bảy phá hai tím giày cửa á. Quần độc máy khoan đang chỉ viết. Kim chỉ đạp hết anh hết hai.	0	2023-12-09 12:53:08.328952	2023-12-09 12:53:08.328952
27	Cát Uy Hồ	vBTGaTgxFSFiB4n	HuuVuong.7koan@gmail.com	68	1	2023-08-12 07:13:28	https://avatars.githubusercontent.com/u/82632897	20181779	bơi	đỏ	cửa	Tàu tám viết. Độc lỗi ừ đồng. Thích tám xuồng mây khoảng.	0	2023-12-09 12:53:08.329998	2023-12-09 12:53:08.329998
28	Bích Điệp Lê	PWKnXhU6IQl2uZX	KimLy93@yahoo.com	27	0	2023-07-01 21:28:57	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/801.jpg	20192447	chín	thích	yêu	Ờ xanh leo bạn hóa độc chết. Đạp ghế tôi kim kim á tám bơi hương độc. Dép thì đánh biết việc á hàng tôi đồng.	0	2023-12-09 12:53:08.331265	2023-12-09 12:53:08.331265
29	Minh Dân Đinh	dM194b0LS5BdYP4	XuanThuy.Tang90@yahoo.com	44	0	2023-06-13 15:48:27	https://avatars.githubusercontent.com/u/61430483	20186613	tủ	anh	mây	Trăng chìm việc cửa đá. Đâu xe tủ bốn ác. Sáu vá bè.	1	2023-12-09 12:53:08.332364	2023-12-09 12:53:08.332364
30	Nhã Sương Lý	ONBKF6hM5JOz2gE	TheVinh_Tran46@yahoo.com	26	1	2023-06-19 22:56:04	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/1136.jpg	20215870	biết	độc	ruộng	Á áo cái bảy chỉ vàng đâu. Khoan đâu thương thích được biết. Đánh thì thì hàng đập ba.	1	2023-12-09 12:53:08.333483	2023-12-09 12:53:08.333483
31	Việt Nhân Bùi	RVRko_nU218lDs2	GiaNhi.7kinh@yahoo.com	75	0	2023-02-04 12:44:31	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/802.jpg	20182063	ờ	đập	hai	Bảy mây tím tủ việc chỉ quần tàu bàn. Máy nước ừ nước tàu sáu biển leo nón cái. Bàn ác khoảng một nước đỏ kim.	1	2023-12-09 12:53:08.334547	2023-12-09 12:53:08.334547
32	Ánh Nguyệt Trịnh	L0iihOheI7Q_4M6	TanPhat_Le42@gmail.com	20	1	2023-05-10 13:26:31	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/79.jpg	20168042	cửa	bạn	nước	Nha mướn thương được chín cái thuyền hóa viết. Con một chìm. Nha thương đạp hương thuyền đập phá đâu tám nón.	1	2023-12-09 12:53:08.335774	2023-12-09 12:53:08.335774
33	Việt Khải Hoàng	8wdtyy88vwmbOBn	NguyenBong.Mai@gmail.com	81	0	2023-02-18 20:23:12	https://avatars.githubusercontent.com/u/76997652	20237060	áo	đồng	cái	Con nón độc yêu lầu viết. Tôi gió mướn ác. Con hết phá.	1	2023-12-09 12:53:08.33681	2023-12-09 12:53:08.33681
34	Quốc Hải Đinh	qJClimbyqZnEWty	NhanNguyen.Ho63@hotmail.com	58	1	2023-07-19 04:39:17	https://avatars.githubusercontent.com/u/90256565	20160073	đỏ	việc	hai	Vẽ thuê xuồng. Tím khoan viết áo tủ. Nước thế máy làm ghét một thôi máy khâu bàn.	0	2023-12-09 12:53:08.337877	2023-12-09 12:53:08.337877
35	Diễm My Mai	OHjtoWr02qxMgpC	DanKhanh.Pham@gmail.com	51	1	2022-12-26 11:48:06	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/534.jpg	20180969	bơi	biết	á	Xuồng ờ leo máy. Ghế được đập bơi ờ tôi. Bạn ừ khâu được tủ cửa tủ ngọt anh ác.	1	2023-12-09 12:53:08.339056	2023-12-09 12:53:08.339056
36	Song Oanh Lê	dam27jx3iutPgGB	QuocPhong.Nguyen54@gmail.com	15	1	2023-07-13 17:57:46	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/44.jpg	20177115	thì	thích	bảy	Vẽ nha hàng ờ ừ lỗi dép mua bơi tôi. Mượn kim đánh biết nhà anh. Cửa lỗi nhà bơi hai là tàu bảy.	1	2023-12-09 12:53:08.340267	2023-12-09 12:53:08.340267
37	Thế Tường Đặng	NHY_fqiZ1bTlTk9	ThienMy.Pham29@gmail.com	99	0	2023-05-03 08:49:52	https://avatars.githubusercontent.com/u/98280639	20141566	lầu	khoảng	mây	Anh ruộng vá. Đang hai bạn nón tôi thuyền mướn chết khâu tủ. Con thì cửa tui thuyền.	0	2023-12-09 12:53:08.341386	2023-12-09 12:53:08.341386
38	Mỹ Thuận Lâm	VbKuj8RguXyPCvH	PhuocNguyen_Mai@gmail.com	86	1	2023-08-08 08:37:16	https://avatars.githubusercontent.com/u/91409072	20158951	lầu	đang	đang	Bảy đồng một anh mướn. Ghét xe đá tủ khâu nhà nghỉ hương. Bè trăng bơi là gì.	1	2023-12-09 12:53:08.342692	2023-12-09 12:53:08.342692
39	Kiều Loan Nguyễn	DMU6SH9lzAF0YIC	NgocLy11@gmail.com	89	1	2023-09-16 00:27:19	https://avatars.githubusercontent.com/u/51279746	20172376	chìm	viết	thì	Trời ngọt thuê mây vá đá ghế bạn tám ghét. Mây ờ cái giày khâu. Cửa đá bạn dép mượn thuê.	0	2023-12-09 12:53:08.343938	2023-12-09 12:53:08.343938
40	Việt Quyết Đinh	dTTxFp9jY5NP9NT	TuyetNga92@yahoo.com	1	1	2023-04-23 09:17:46	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/1080.jpg	20234445	biển	viết	trăng	Vàng bè á quê mười tôi. Bè anh đâu giày đá. Nước thuê kim đồng được yêu xanh.	1	2023-12-09 12:53:08.345067	2023-12-09 12:53:08.345067
41	Thụy Trinh Trịnh	zZ6IuGpL4IBoA5i	7kongKhanh_Vu@hotmail.com	82	1	2023-11-21 18:24:40	https://avatars.githubusercontent.com/u/62044857	20229762	dép	bè	không	Thuê bạn vàng mướn. Mây nước giết trời lầu hương quê quần. Cửa tủ vẽ yêu ngọt em con.	1	2023-12-09 12:53:08.34617	2023-12-09 12:53:08.34617
42	Tân Bình Phạm	pGha9HBURw3bnaY	AnhVu43@gmail.com	27	0	2023-04-16 02:07:17	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/153.jpg	20202304	lỗi	biển	bốn	Ba xuồng ác đã gió quê cửa yêu áo làm. Đang thích cửa thôi khâu khoảng ngọt tôi núi chìm. Xe á nhà.	1	2023-12-09 12:53:08.347214	2023-12-09 12:53:08.347214
43	Kiên Lâm Trịnh	MAY1pgvV5hXqRKf	ChiThanh.Phan@hotmail.com	68	0	2023-05-25 10:36:06	https://avatars.githubusercontent.com/u/74899548	20152894	thương	khâu	chết	Hai tàu xanh máy may đạp thích thì bè chín. Nghỉ tui tủ chín ừ cửa lầu áo. Đánh vẽ bảy.	1	2023-12-09 12:53:08.348247	2023-12-09 12:53:08.348247
44	Thái Hòa Hoàng	4i_ysJqL7NL_260	AnhThai.Trinh@yahoo.com	67	0	2023-11-12 12:39:55	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/384.jpg	20163158	yêu	hàng	mướn	Gì lầu vá cái. Chìm giết mượn biển. Thì giày vàng đâu tím máy kim đập.	0	2023-12-09 12:53:08.349371	2023-12-09 12:53:08.349371
45	Thanh Tùng Đinh	bIWP0J0_6QPKN8C	MyLe.Mai@gmail.com	30	1	2023-11-19 05:03:21	https://avatars.githubusercontent.com/u/80484789	20154237	ghét	bốn	tím	Vá đánh vẽ. Bàn mượn đã hương viết hai làm quần xuồng. Máy anh độc việc tô không.	1	2023-12-09 12:53:08.350496	2023-12-09 12:53:08.350496
46	Hoàn Kiếm Vũ	Bh4_3DY_FoyytfY	HoaLy_Le39@gmail.com	4	0	2023-08-02 16:54:31	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/39.jpg	20217099	núi	lỗi	trời	Máy thôi phá giết mười năm anh đỏ. Bàn năm yêu bạn hết. Lỗi ba đã lỗi ừ thì.	0	2023-12-09 12:53:08.351555	2023-12-09 12:53:08.351555
47	Việt Quyết Lê	K0NFg9LPM3flgV5	BaoVy_Tran86@yahoo.com	59	1	2023-02-05 09:32:56	https://avatars.githubusercontent.com/u/91823255	20168740	hóa	ghế	núi	Hóa ba mướn. Nhà trăng giày đá việc xanh tám giày cửa. Mượn sáu mây mười giết đâu thế khoảng.	1	2023-12-09 12:53:08.352747	2023-12-09 12:53:08.352747
48	Đình Ngân Phan	Su2sPXoMV8R2ZLB	ThanhHuy_7kao@hotmail.com	71	0	2022-12-21 04:50:18	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/431.jpg	20212576	không	hàng	đánh	Mượn vàng dép hóa thuyền ừ nha bảy. Biển xanh nha kim quê. Xuồng ghét chỉ áo.	0	2023-12-09 12:53:08.353803	2023-12-09 12:53:08.353803
49	Lương Quyền Bùi	qygnhVNMnYz5IRB	7kongBang.Ngo94@yahoo.com	30	1	2023-09-28 07:33:37	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/173.jpg	20238673	hóa	bè	phá	Tám ờ gió á biết thôi núi ngọt. Một yêu cửa đá đang anh ba áo tàu gì. Hương nước quê ruộng một sáu đâu con.	1	2023-12-09 12:53:08.354874	2023-12-09 12:53:08.354874
50	Tú Quỳnh Đinh	wd_jG4U49J6LWA6	ManhNghiem89@yahoo.com	34	1	2023-04-20 12:09:58	https://avatars.githubusercontent.com/u/82579377	20213920	nha	chết	áo	Đạp đập đã giày. Tô trăng anh trời. Mướn tủ hương á xe bơi.	1	2023-12-09 12:53:08.355864	2023-12-09 12:53:08.355864
51	Song Lam Vương	Jl9fXB0YPxwQqM9	AnhThu.Duong30@yahoo.com	66	1	2023-10-09 20:31:39	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/553.jpg	20158973	thuê	thuê	phá	Đỏ hương may đá đập chín đá mượn. Mướn thế làm bảy phá đồng vá mười bè. Ghế gió ừ.	0	2023-12-09 12:53:08.356977	2023-12-09 12:53:08.356977
52	Giang Lam Tô	wbqYV8viZmv3LP7	AiKhanh.Trinh3@yahoo.com	31	0	2023-10-11 03:56:26	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/194.jpg	20219523	tui	tám	nhà	Biết phá thích bơi khoan quần trời bè máy. Gió biết chỉ đánh. Chín khoan mười bạn núi bốn tui ác bạn khoảng.	0	2023-12-09 12:53:08.358009	2023-12-09 12:53:08.358009
53	Thanh Nhã Hoàng	lm5uSlhWcmUl1Xc	TruongChinh.Nguyen16@gmail.com	15	1	2023-08-29 14:00:39	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/811.jpg	20184471	kim	là	yêu	Gì thế kim thích khâu. Đá độc tô leo bảy ác chìm cái ba ba. Cửa giày hai á.	0	2023-12-09 12:53:08.359038	2023-12-09 12:53:08.359038
54	Khánh Hà Phùng	jGud6t20n8pTST4	HuuChien56@yahoo.com	41	1	2023-06-05 08:08:43	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/1223.jpg	20208983	anh	xe	thuyền	Trăng đập hai là quần. Ghế trời quần hương lỗi ba anh tô may thôi. Bốn phá mượn ngọt không.	0	2023-12-09 12:53:08.360103	2023-12-09 12:53:08.360103
55	Trung Anh Đoàn	EG3pnpdud6nUJFJ	HongNhuan_Le@gmail.com	95	1	2023-08-27 06:54:53	https://avatars.githubusercontent.com/u/6498366	20208808	chết	biển	kim	Bàn trời đập áo năm ba tủ đạp năm. Tôi trăng chỉ ừ lầu. Phá giày lỗi xe làm.	0	2023-12-09 12:53:08.361135	2023-12-09 12:53:08.361135
56	Loan Châu Phan	n8_2EKm6V6cTNpQ	TruongPhat19@gmail.com	0	1	2023-05-11 21:09:04	https://avatars.githubusercontent.com/u/17073129	20179302	xanh	núi	ác	Xuồng tím tím nhà sáu nhà. Làm bảy mười một bạn á chết mây may gì. Thích đã đâu núi lầu leo nước.	0	2023-12-09 12:53:08.362148	2023-12-09 12:53:08.362148
57	Thiên Lạc Vũ	HHFgs6p599COesw	KimYen44@yahoo.com	20	1	2023-10-09 09:52:41	https://avatars.githubusercontent.com/u/62499403	20227264	đỏ	nhà	đá	Bốn tui hai tám chìm nghỉ mười. Gì được bè lỗi mướn độc chết hai thích. Ngọt thôi chết á một giày mướn là ghế biết.	1	2023-12-09 12:53:08.363239	2023-12-09 12:53:08.363239
58	Xuân Dung Lê	mZVxSxN_2JYw6gF	TanThanh_Bui@yahoo.com	100	1	2023-03-05 22:33:24	https://avatars.githubusercontent.com/u/75666695	20203185	đang	bạn	vàng	Giày nước em yêu đã. Viết ba ác máy máy bảy. Cửa lầu quần đạp mười hết.	0	2023-12-09 12:53:08.364249	2023-12-09 12:53:08.364249
59	Hiếu Học Tăng	kVZpVitt7pnBCCK	7kinhPhuc_To@hotmail.com	47	1	2023-11-12 16:39:19	https://avatars.githubusercontent.com/u/86285511	20226139	một	hóa	mượn	Được bạn á. Đồng độc máy hàng. Đạp kim một chết.	0	2023-12-09 12:53:08.365265	2023-12-09 12:53:08.365265
60	Thùy Giang Nguyễn	NVcTO_rcAnsbf4M	NhatPhuong19@hotmail.com	26	1	2023-09-07 14:20:42	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/117.jpg	20155985	chỉ	leo	quê	Ba tím khoảng bảy xuồng nón ác con. Ờ yêu hóa ghét bạn đã bốn đỏ mướn đâu. Đỏ viết bảy thế biết hàng.	0	2023-12-09 12:53:08.366266	2023-12-09 12:53:08.366266
61	Gia Đạo Lý	S3ZWMbrBEFJIZCF	ThuanAnh_Vu@yahoo.com	60	1	2023-02-03 08:31:14	https://avatars.githubusercontent.com/u/91758229	20155752	thôi	thuyền	gì	Gì bảy ngọt gió ba phá lỗi viết. Đập ừ khoan biết được chín ngọt khoan mười bè. Yêu thuyền lầu tám.	0	2023-12-09 12:53:08.367314	2023-12-09 12:53:08.367314
62	Quỳnh Trang Trần	fYkceTF4waB3JED	TuanHai.Truong@gmail.com	79	1	2023-08-23 03:08:42	https://avatars.githubusercontent.com/u/95714959	20221307	ừ	khoảng	khâu	Đồng đạp ừ sáu đập ghế yêu. Đập anh nước khoan mượn đánh viết tủ tôi đá. Bàn hương giết.	1	2023-12-09 12:53:08.368303	2023-12-09 12:53:08.368303
63	Thảo Nghi Đỗ	tN0eFNLGQ1MGKsh	TamThanh.Phan@hotmail.com	22	0	2023-10-12 09:36:44	https://avatars.githubusercontent.com/u/65060004	20178208	vá	mua	năm	Chìm trăng em nước ngọt tui sáu biển thuyền chết. Gì bạn mượn hàng chết bốn bè dép vá ghét. Đập làm ruộng á xanh phá ghét ghét.	0	2023-12-09 12:53:08.369355	2023-12-09 12:53:08.369355
64	Trầm Hương Trương	JSqRaSpJoUMEN3D	TinhNhi.Ho87@yahoo.com	58	0	2023-07-24 03:59:33	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/715.jpg	20237809	hết	em	nha	Biết gió mua. Chỉ đồng khoảng. Dép giết em hai.	1	2023-12-09 12:53:08.370453	2023-12-09 12:53:08.370453
65	Khắc Anh Trương	neLEEKyBdd5VM3a	HaoNhi.Le86@hotmail.com	21	0	2023-07-15 19:29:04	https://avatars.githubusercontent.com/u/71164949	20152557	vàng	hai	mướn	Nghỉ nón nước việc ừ chỉ gì đâu một biết. Leo tàu mây cái đánh. Quần khoảng mười xe.	0	2023-12-09 12:53:08.371512	2023-12-09 12:53:08.371512
66	Phong Dinh Dương	zaisdxeCnzsM_Ov	7kinhHao.7ko57@yahoo.com	10	1	2023-08-11 06:06:25	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/707.jpg	20141070	lầu	thuyền	thôi	Kim đang nghỉ máy ghế giết áo may lầu. Ruộng yêu áo. Vàng ba giày vá thuyền hết.	1	2023-12-09 12:53:08.372594	2023-12-09 12:53:08.372594
67	Vinh Quốc Phạm	duyRc1OXSaGS9dx	7kongNguyen11@hotmail.com	72	1	2023-05-08 23:30:47	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/82.jpg	20157741	ba	hóa	đá	Thế gió vẽ hương mười. Tui anh ghế tàu trăng tủ khoan bàn mười đâu. Tủ quê bảy ngọt mây ghế.	1	2023-12-09 12:53:08.373788	2023-12-09 12:53:08.373788
68	Hiếu Dụng Phạm	O9lgAwn5l8yuIHD	MinhCanh.Phung@yahoo.com	73	1	2023-11-11 19:56:13	https://avatars.githubusercontent.com/u/54802762	20142522	xuồng	cửa	thuê	Được hương biết không đỏ thì. Tui tôi xe mây ờ gì. Hóa độc tàu.	0	2023-12-09 12:53:08.375314	2023-12-09 12:53:08.375314
69	Hoàng Long Trương	BbwTdyshoVg29C7	XuanBao_Ly@yahoo.com	39	0	2023-02-07 00:27:15	https://avatars.githubusercontent.com/u/26214996	20148204	biết	cửa	bảy	Ghét viết mây kim đồng thuê đạp biết đánh gì. Chết thuê kim bè vẽ anh. Vá sáu mua tôi.	0	2023-12-09 12:53:08.376437	2023-12-09 12:53:08.376437
70	Hoàng Việt Đào	LarDChsWNVBA_lG	NhuTran_Hoang@gmail.com	92	0	2023-01-07 07:32:07	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/282.jpg	20165987	đồng	giết	tàu	Áo nón hàng ờ. Khâu tàu vẽ máy ừ máy mây không năm. Leo thuê mượn phá đá đỏ trăng ghế ghế.	1	2023-12-09 12:53:08.377583	2023-12-09 12:53:08.377583
71	Khắc Ninh Đoàn	kOjX2CSjCrYO1mM	ThanhDan_Pham59@yahoo.com	67	0	2023-08-01 04:02:20	https://avatars.githubusercontent.com/u/12382898	20179699	gì	đỏ	độc	Chỉ bàn đập được nha trời thuê lầu. Tui bạn chín kim viết em phá đánh chết đỏ. Chết đã lầu đỏ nghỉ.	1	2023-12-09 12:53:08.378631	2023-12-09 12:53:08.378631
72	Dương Khánh Bùi	9Cvun3T7IZPvMWn	Thuc7kao_Le@gmail.com	45	0	2023-10-13 00:41:52	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/569.jpg	20142123	bàn	giết	gì	Giết sáu thích anh. Độc tủ nhà tím giày không thế máy đập. Nón chìm con thế đập bàn gì.	1	2023-12-09 12:53:08.379623	2023-12-09 12:53:08.379623
73	Quang Trọng Bùi	0Nlzpx50ZDOhgxE	TruongVu28@yahoo.com	55	0	2023-08-05 21:27:56	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/1014.jpg	20235242	ừ	biển	đồng	Thương thích chín thuyền khoan tám đồng máy mười. Lỗi tàu là giết giày biết đạp. Không tàu chín đá ngọt giết chìm.	0	2023-12-09 12:53:08.380638	2023-12-09 12:53:08.380638
74	Huy Kha Trần	A8bEA_WoqYRfENJ	7kinhPhu_Duong10@gmail.com	78	0	2023-06-09 04:48:33	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/908.jpg	20217692	cái	vẽ	vá	Mướn xuồng quê thương tám thôi ngọt khâu đá đánh. Hết nước yêu xuồng thế độc giết vá. Khoan mười đá ừ nước tím bè dép quê bơi.	1	2023-12-09 12:53:08.38165	2023-12-09 12:53:08.38165
75	Phượng Bích Phạm	kRCcaY3ev3yQyCx	LinhSan41@gmail.com	24	0	2023-01-07 08:38:56	https://avatars.githubusercontent.com/u/32744672	20238192	bốn	đã	áo	Bốn đồng ghét quê ruộng kim ba. Quê hàng thuyền. Biển xuồng xuồng sáu.	0	2023-12-09 12:53:08.382626	2023-12-09 12:53:08.382626
76	Diễm Liên Trần	V2nOnoMxGYXNp0P	MyThuan43@yahoo.com	3	1	2023-08-29 21:17:15	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/487.jpg	20148917	vẽ	đang	mua	Biển mây xe nha ruộng vẽ trời quê. Ờ hàng quần á gì. Núi gì mướn đồng gió đỏ.	0	2023-12-09 12:53:08.383675	2023-12-09 12:53:08.383675
77	Huy Phong Hoàng	rHR1cK7OgrCFN5V	ThaoNghi.To1@hotmail.com	59	1	2023-01-09 17:21:22	https://avatars.githubusercontent.com/u/19648575	20203383	thuyền	tô	bơi	Thế tô chỉ biển đâu cái nghỉ tủ. Sáu mười xuồng đồng không thuyền. Năm đang quần chìm may.	0	2023-12-09 12:53:08.384817	2023-12-09 12:53:08.384817
78	Kim Cương Phạm	Sv9LcD9QYGC9KwT	HanhVi_Bui78@gmail.com	12	1	2023-10-30 20:09:05	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/1117.jpg	20153567	lầu	lầu	con	Hai bơi khoảng khâu tôi. Tô may mười ghế vá xuồng hóa. Một phá bốn nước.	0	2023-12-09 12:53:08.386042	2023-12-09 12:53:08.386042
79	Thụy Du Đinh	txFiGefYdoVqhtd	Trung7kuc_Tran@gmail.com	81	1	2023-05-09 21:08:22	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/886.jpg	20198639	anh	khoảng	tàu	Quần đồng bàn nhà giày hóa vá làm tím. Chết anh tô hai tàu trăng tui xe trời. Sáu thôi nhà hai khoảng dép tàu đạp núi.	1	2023-12-09 12:53:08.387107	2023-12-09 12:53:08.387107
80	Cát Ly Dương	rT8ZWNtahkBrxZN	MinhHanh.7kinh@hotmail.com	91	1	2023-06-08 14:20:48	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/300.jpg	20177328	làm	đã	nghỉ	Năm viết viết lỗi đánh tám trăng. Ghế sáu tô bơi hóa chỉ đánh ghét may leo. Đập nón á chỉ.	0	2023-12-09 12:53:08.388119	2023-12-09 12:53:08.388119
81	Thái Dương Hoàng	OFpeLYjYeJBBGjH	MinhGiang_Mai@gmail.com	76	0	2023-08-16 17:13:30	https://avatars.githubusercontent.com/u/40509488	20195634	không	ruộng	hương	Lỗi mua lầu gió nha vá chỉ. Xuồng ghét đánh một chết năm vẽ. Tủ thuê đánh là.	1	2023-12-09 12:53:08.389176	2023-12-09 12:53:08.389176
82	Phương Thể Hồ	2mlKq7p71iqOJpw	ThuVong.Le@yahoo.com	74	1	2023-06-03 10:05:43	https://avatars.githubusercontent.com/u/30037071	20203116	anh	ác	bốn	Khoảng hương cái nha ruộng con đá. Đạp đá hết tô mười. Con tui biết dép chín thuê.	1	2023-12-09 12:53:08.390189	2023-12-09 12:53:08.390189
83	Phượng Bích Hồ	A4YTBSvo86_O29C	ThanhNhung51@yahoo.com	54	0	2023-04-24 04:42:21	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/755.jpg	20221702	giết	độc	hết	Đang đá kim mây. Lầu áo đạp vẽ đâu vàng. Chỉ thì quê phá biển khoảng không.	0	2023-12-09 12:53:08.391271	2023-12-09 12:53:08.391271
84	Dạ Thi Hồ	4qpCohHpD2pzvU8	HieuHoc_Tran83@gmail.com	32	1	2023-11-23 02:23:29	https://avatars.githubusercontent.com/u/17585372	20200704	bàn	đồng	xe	Chìm mây em ờ đang chết hóa đạp mượn. Đỏ trăng hương bàn bốn. Tôi thì mây làm yêu xanh hóa bạn anh đã.	1	2023-12-09 12:53:08.39238	2023-12-09 12:53:08.39238
85	Thục Trang Phạm	vTUk7rIGL_ypgmp	VanTuyen_Vuong@hotmail.com	40	1	2023-05-13 13:10:39	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/774.jpg	20145677	thuyền	xuồng	độc	Đã lỗi trời kim mây năm á kim mười. Nha ghế ghế. Nha chín xanh nha thôi đồng.	0	2023-12-09 12:53:08.393468	2023-12-09 12:53:08.393468
86	Huệ My Đào	bSZinXaaABTVhPi	KimThy63@gmail.com	95	0	2023-03-14 20:06:14	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/475.jpg	20215825	đang	máy	lầu	Ác tím vá. Thuê đỏ mua may thì tô độc xuồng á. Bàn đâu xe.	1	2023-12-09 12:53:08.394495	2023-12-09 12:53:08.394495
87	Đức Tài Lê	SNq7QSv3zxy_gJj	HuuThuc86@yahoo.com	52	0	2023-05-04 04:09:12	https://avatars.githubusercontent.com/u/4922404	20185207	hết	đang	không	Ruộng cửa bàn núi nha tui đạp dép. Anh đá quê ruộng ghế xanh lầu một ba chết. Nhà đỏ là quần hết bè trời xanh khâu biển.	0	2023-12-09 12:53:08.395525	2023-12-09 12:53:08.395525
88	Quang Bửu Trương	u953GYaP_pgJB2a	DuyenNuong45@yahoo.com	19	0	2023-04-14 05:39:32	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/588.jpg	20163331	ừ	đã	mây	Thế một vẽ tôi. Năm đánh bơi gió. Chết kim năm hóa.	0	2023-12-09 12:53:08.396543	2023-12-09 12:53:08.396543
89	Xuân Uyên Phạm	VZ_9c5lHHZHU7xW	AnhQuan_Ho6@hotmail.com	28	1	2023-08-04 17:44:18	https://avatars.githubusercontent.com/u/43650215	20213053	hàng	là	khoảng	Á ruộng tám chìm á thì kim lỗi. Leo khâu tám đã biết. Yêu áo mượn thích gì á làm nón.	1	2023-12-09 12:53:08.397588	2023-12-09 12:53:08.397588
90	Thanh Hảo Nguyễn	UithoR9w7zeLHwj	MyKieu.7kinh@hotmail.com	91	1	2023-06-29 04:14:39	https://avatars.githubusercontent.com/u/48106022	20164225	tủ	hai	đỏ	Gì xuồng chỉ. Bè nghỉ đập. Ba là tủ.	1	2023-12-09 12:53:08.398724	2023-12-09 12:53:08.398724
91	Diễm Trinh Lâm	0iCk0Cd7G9YxC4U	YenPhuong_Ho25@gmail.com	18	0	2023-11-09 13:25:46	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/346.jpg	20166976	nha	yêu	lỗi	Xanh áo vàng biển hết ruộng thương. Dép trăng tôi. Hóa tui không mây tủ.	0	2023-12-09 12:53:08.399795	2023-12-09 12:53:08.399795
92	Diễm Liên Phan	QXzHHBkNlLY15s0	7kangAn.Phung@gmail.com	38	0	2023-08-10 02:57:41	https://avatars.githubusercontent.com/u/66311654	20223462	khâu	kim	tím	Ờ chìm á đỏ giày khoan thôi ác biết. Bạn vàng tôi vá thuê nước cửa vẽ việc. Chết núi vàng ngọt.	0	2023-12-09 12:53:08.400836	2023-12-09 12:53:08.400836
93	Gia Khánh Hà	dEHAj6n5IChNJOB	KhanhLy.Vu54@hotmail.com	12	0	2023-06-10 07:29:51	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/875.jpg	20232948	tui	áo	tô	Thuyền hết không bơi tủ thì trăng. Ngọt hết leo vá vẽ chỉ. Mây ba kim trăng mượn trời anh em gió biển.	1	2023-12-09 12:53:08.401892	2023-12-09 12:53:08.401892
94	Mỹ Tâm Dương	PLvDN9mlBwLGPqI	ThienLuong.Vuong@yahoo.com	5	0	2023-08-27 13:55:23	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/185.jpg	20205196	thích	tủ	độc	Cái quê bảy việc cửa. Hóa khoảng tôi thuyền thuê khoan không. Mướn ừ con là.	0	2023-12-09 12:53:08.402921	2023-12-09 12:53:08.402921
95	Thế Doanh Trần	8NrvTJqfGqGNdsK	DiepVy69@yahoo.com	80	1	2023-07-05 17:33:58	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/896.jpg	20185035	thôi	gì	tàu	Mây chết mướn áo leo thuyền tui. Vá tàu dép tàu thuyền gì chìm núi nón ờ. Núi cái khâu nước tôi vá đồng trời đá đâu.	1	2023-12-09 12:53:08.403957	2023-12-09 12:53:08.403957
96	Thương Huyền Trương	Dylk5a470RotIXz	ThienLuong_Phan@yahoo.com	20	1	2023-04-27 02:01:46	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/372.jpg	20175092	thương	hóa	khâu	Đập một đang thương. Máy nha đâu quần thương nước sáu. Đạp tô đá hàng thế vàng năm hóa mướn cái.	1	2023-12-09 12:53:08.404995	2023-12-09 12:53:08.404995
97	Bá Thành Đặng	MOC6q0JqjqPcOUS	VietHong.Ho@gmail.com	76	0	2023-04-03 08:24:16	https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/203.jpg	20164679	ba	xanh	tui	Cái anh may đạp tô cửa thích tám nón hàng. Tủ nha vẽ đạp tủ ghế đã. Áo một một.	1	2023-12-09 12:53:08.40598	2023-12-09 12:53:08.40598
98	Bạch Mai Phạm	oYjpo7itER8JTKF	GiaHuy_Phung@gmail.com	40	1	2023-02-02 05:55:39	https://avatars.githubusercontent.com/u/87073540	20229449	thôi	áo	đâu	Máy bè máy bạn đang. Xanh ruộng đạp tàu tám ba chìm mười sáu. Gió đập khâu đỏ ghét thôi thôi em.	0	2023-12-09 12:53:08.406967	2023-12-09 12:53:08.406967
99	Ngọc Khương Phùng	tuAy9_6Go6H6u6P	VanQuyen_Tang@gmail.com	69	0	2023-05-22 23:10:03	https://avatars.githubusercontent.com/u/44272653	20163326	thuê	cái	tím	Khoảng ruộng mướn thích cửa. Nghỉ việc máy đang phá hàng tàu hết. Núi viết con thôi tám yêu mua năm lỗi.	0	2023-12-09 12:53:08.407928	2023-12-09 12:53:08.407928
100	Nghị Lực Tăng	VG6GZjQ1B3t5U7X	BichChieu.Ly83@yahoo.com	100	1	2023-04-09 19:06:36	https://avatars.githubusercontent.com/u/55004604	20215257	chín	ruộng	chín	Phá ngọt bàn nghỉ tui giày. Dép thích bơi năm bốn. Bốn cửa hàng đập việc.	0	2023-12-09 12:53:08.408947	2023-12-09 12:53:08.408947
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

SELECT pg_catalog.setval('public.question_tag_id_seq', 3, true);


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
-- Name: tags_tagname_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX tags_tagname_uindex ON public.tags USING btree (tagname);


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

