# encoding: UTF-8

module SUNAT
  class TaxCategory
    include Model
    
    TAX_EXEMPTION_REASON_CODES = {
      '10' => 'Gravado - Operación Onerosa',
      '11' => 'Gravado – Retiro por premio',
      '12' => 'Gravado – Retiro por donación',
      '13' => 'Gravado – Retiro',
      '14' => 'Gravado – Retiro por publicidad',
      '15' => 'Gravado – Bonificaciones',
      '16' => 'Gravado – Retiro por entrega a trabajadores',
      '20' => 'Exonerado - Operación Onerosa',
      '30' => 'Inafecto - Operación Onerosa',
      '31' => 'Inafecto – Retiro por Bonificación',
      '32' => 'Inafecto – Retiro',
      '33' => 'Inafecto – Retiro por Muestras Médicas',
      '34' => 'Inafecto - Retiro por Convenio Colectivo',
      '35' => 'Inafecto – Retiro por premio',
      '36' => 'Inafecto - Retiro por publicidad',
      '40' => 'Exportación'
    }
    
    CALC_SYSTEM_TYPES = {
      '01' => 'Sistema al valor (Apéndice IV, lit. A – T.U.O IGV e ISC)',
      '02' => 'Aplicación del Monto Fijo (Apéndice IV, lit. B – T.U.O IGV e ISC)',
      '03' => 'Sistema de Precios de Venta al Público (Apéndice IV, lit. C – T.U.O IGV e ISC)'
    }
    
    property :tax_exemption_reason_code,  String
    property :tier_range,                 String
    property :tax_scheme,                 TaxScheme
    
    validates :tax_exemption_reason_code, inclusion: { in: TAX_EXEMPTION_REASON_CODES.keys }
    validates :tier_range, inclusion: { in: CALC_SYSTEM_TYPES.keys }
    
    def build_xml(xml)
      xml['cac'].TaxCategory do        
        xml['cbc'].TaxExemptionReasonCode(tax_exemption_reason_code) if tax_exemption_reason_code
        xml['cbc'].TierRange(tier_range) if tier_range
      
        tax_scheme.build_xml(xml)
      end
    end
  end
end
