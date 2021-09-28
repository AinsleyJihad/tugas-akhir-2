<?php if(!defined('BASEPATH')) exit ('No direct script access allowed');

class app_model extends CI_Model {

     public function __construct()
     {
          parent::__construct();
     }

     public function semua()
     {
          $this->db->select('*');
          $this->db->from('divisi');
          $this->db->order_by('id_divisi', 'DESC');

          return $this->db->get();
     }
}